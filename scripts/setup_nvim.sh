#!/usr/bin/bash

source $HOME/.dotfiles/scripts/setup_helpers.sh

sudo mkdir -p /opt/nvim
cd /opt/nvim
sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo chmod +x nvim.appimage
sudo ./nvim.appimage --appimage-extract
sudo ln -s /opt/nvim/squashfs-root/AppRun /usr/bin/nvim

create_symlink $HOME/.dotfiles/.config/nvim $HOME/.config/nvim
