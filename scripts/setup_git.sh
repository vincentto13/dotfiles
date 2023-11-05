#!/usr/bin/bash

source $HOME/.dotfiles/scripts/setup_helpers.sh

echo "Setup Git"

create_symlink $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
