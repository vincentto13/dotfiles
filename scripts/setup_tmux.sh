#!/bin/bash

source $HOME/.dotfiles/scripts/setup_helpers.sh

install_tmux() {
  if command -v brew &>/dev/null; then
    echo "Detected Homebrew (macOS)"
    brew install tmux
  elif command -v apt-get &>/dev/null; then
    echo "Detected APT package manager (Ubuntu or Debian-based)"
    sudo apt-get update
    sudo apt-get install -y tmux
  elif command -v apk &>/dev/null; then
    echo "Detected Alpine package manager (Alpine Linux)"
    apk update
    apk add tmux
  elif command -v yum &>/dev/null; then
    echo "Detected YUM package manager (Red Hat-based)"
    sudo yum install tmux
  else
    echo "Error: Unsupported operating system or package manager. You'll need to install Zsh manually."
    exit 1
  fi
}

install_tmux_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  fi
}

install_tmux
install_tmux_tpm

mkdir -p $HOME/.config/tmux
create_symlink $HOME/.dotfiles/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
