#!/bin/bash

exit 0

create_or_update_symlink() {
  source_path="$1"
  destination_dir="$2"

  # Ensure the source path exists
  if [ ! -e "$source_path" ]; then
    echo "Error: Source path does not exist."
    return 1
  fi

  # Ensure the destination directory exists
  if [ ! -d "$destination_dir" ]; then
    echo "Error: Destination directory does not exist."
    return 1
  fi

  # Extract the directory structure from the source path
  source_dir="$(dirname "$source_path")"

  # Create the destination directory structure
  destination_path=$destination_dir/$(realpath --relative-to="$destination_dir" $source_dir)
  mkdir -p "$destination_path"

  # Check if a symlink exists at the destination
  if [ -L "$destination_path/$(basename "$source_path")" ]; then
    # Check if the symlink is valid
    if [ "$(readlink "$destination_path/$(basename "$source_path")")" != "$source_path" ]; then
      # Recreate the symlink
      ln -sf "$source_path" "$destination_path/$(basename "$source_path")"
      echo "Recreated invalid symlink: $destination_path/$(basename "$source_path") -> $source_path"
    else
      echo "Symlink already exists and is valid: $destination_path/$(basename "$source_path")"
    fi
  else
    if [ -e "$destination_path/$(basename "$source_path")" ]; then
      echo "File exists, creating a backup"
      mv "$destination_path/$(basename "$source_path")" "$destination_path/$(basename "$source_path").bak" 
    fi
    # Create a new symlink
    ln -s "$source_path" "$destination_path/$(basename "$source_path")"
    echo "Created new symlink: $destination_path/$(basename "$source_path") -> $source_path"
  fi
}


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

# ZSH things
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

if [ ! -d "$PLUGINS_CUSTOM/themes/zsh-syntax-highlighting" ]; then
  echo "Installing 'catppuccino' theme for zsh"
  git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ${PLUGINS_CUSTOM}/themes/zsh-syntax-highlighting
fi


echo "Cloning dotfiles..."
DOTFILES_PATH="$HOME/.dotfiles"
if [ ! -d $DOTFILES_PATH ]; then
  git clone https://github.com/vincentto13/dotfiles.git $DOTFILES_PATH
fi;
pushd $DOTFILES_PATH
git pull
popd

for file in $(find $DOTFILES_PATH -type f -not -path "$DOTFILES_PATH/.git/*" | grep "^$DOTFILES_PATH/\."); do
  entry=$(realpath --relative-to="$HOME" $file)
  echo $DOTFILES_PATH/$entry
  #create_or_update_symlink $file $HOME
done

