#!/usr/bin/bash

source $HOME/.dotfiles/scripts/setup_helpers.sh

echo "Install NeoVim"
sudo mkdir -p /opt/nvim
sudo rm -rf /opt/nvim/*
cd /opt/nvim
sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage 2>/dev/null
sudo chmod +x nvim.appimage
sudo ./nvim.appimage --appimage-extract > /dev/null
sudo ln -sf /opt/nvim/squashfs-root/AppRun /usr/bin/nvim
sudo rm /opt/nvim/nvim.appimage

create_symlink $HOME/.dotfiles/.config/nvim $HOME/.config/nvim
