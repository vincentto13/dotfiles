#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root, nor with sudo."
  exit 1
fi

username=$(logname)

package_list="htop tmux zsh unzip"
echo "Will install the following packages '${package_list}'. Please pass a root password for apt command"

sudo -- sh -c "apt update && apt install -y ${package_list}"
if [[ $? -ne 0 ]]; then
  echo "Something went wrong $?"
  exit 2
fi

current_shell=$(getent passwd "$USER" | cut -d: -f7)
if [ "$current_shell" != "$(which zsh)" ]; then
  # Change the user's default shell to Zsh
  echo "Changing default shell to zsh"
  chsh -s $(which zsh) $username
  echo "Changed the default shell for user $username to Zsh."
else
  echo "User $username already has Zsh as their default shell."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

PLUGINS_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$PLUGINS_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions plugin..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${PLUGINS_CUSTOM}/plugins/zsh-autosuggestions
fi

if [ ! -d "$PLUGINS_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntex-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${PLUGINS_CUSTOM}/plugins/zsh-syntax-highlighting
fi

echo "Cloning dotfiles..."
git clone https://github.com/vincentto13/dotfiles.git $HOME/.dotfiles

for file in $HOME/.dotfiles/.*; do
  if [ -f $file ]; then
    filename=$(basename $file)
    makebackup=false
    if [ -L $HOME/$filename ]; then
      echo "Symbolic link"
      pointto=$(realpath $(readlink -- $HOME/$filename))
      if [ "$pointto" == "$file" ]; then
        echo "Symlink correect skip"
        continue
      fi
      makebackup=true
    elif [ -f $HOME/$filename ]; then
      echo "Regular file"
      makebackup=true
    fi
    if [ "$makebackup" == true ]; then
      echo "making backup"
      mv $HOME/$filename $HOME/$filename.bak
    fi
    ln -s $file $HOME
    echo $file
  fi
done
#echo "Installing NeoVim"
#wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
