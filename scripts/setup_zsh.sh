#!/bin/bash

source $HOME/.dotfiles/scripts/setup_helpers.sh

install_zsh() {
  if command -v brew &>/dev/null; then
    echo "Detected Homebrew (macOS)"
    brew install zsh
  elif command -v apt-get &>/dev/null; then
    echo "Detected APT package manager (Ubuntu or Debian-based)"
    sudo apt-get update
    sudo apt-get install -y zsh
  elif command -v apk &>/dev/null; then
    echo "Detected Alpine package manager (Alpine Linux)"
    apk update
    apk add zsh
  elif command -v yum &>/dev/null; then
    echo "Detected YUM package manager (Red Hat-based)"
    sudo yum install zsh
  else
    echo "Error: Unsupported operating system or package manager. You'll need to install Zsh manually."
    exit 1
  fi
}

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

install_zsh_plugins() {
  PLUGINS_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
  if [ ! -d "$PLUGINS_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${PLUGINS_CUSTOM}/plugins/zsh-autosuggestions
  fi

  if [ ! -d "$PLUGINS_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntex-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${PLUGINS_CUSTOM}/plugins/zsh-syntax-highlighting
  fi

  echo "Installing catppuccin theme"
  if [ ! -d "$PLUGINS_CUSTON/themes/catppuccin" ]; then
    git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ${PLUGINS_CUSTOM}/themes/catppuccin
  fi

  echo "Installing PowerLevel10k"
  if [ ! -d "$ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then 
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  fi
}

change_shell() {
  current_shell=$(getent passwd "$USER" | cut -d: -f7)
  if [ "$current_shell" != "$(which zsh)" ]; then
    # Change the user's default shell to Zsh
    echo "Changing default shell to zsh"
    chsh -s $(which zsh) $username
    echo "Changed the default shell for user $username to Zsh."
  else
    echo "User $username already has Zsh as their default shell."
  fi
}

install_zsh
install_oh_my_zsh
install_zsh_plugins
change_shell
create_symlink $HOME/.dotfiles/.zshrc $HOME/.zshrc
create_symlink $HOME/.dotfiles/.p10k.zsh $HOME/.p10k.zsh
