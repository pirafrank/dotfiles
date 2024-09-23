#!/bin/bash

if ! command -v nvim &> /dev/null; then
    echo "Installing neovim..."
else
    echo "neovim already installed"
    exit 0
fi

mkdir -p /tmp/nvim_install
cd /tmp/nvim_install || exit 1

# nb. required: sudo apt-get update && sudo apt-get install -y fuse libfuse2

# install by putting it in PATH
curl -sSL https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o "$HOME/.local/bin/nvim.appimage"
chmod u+x "$HOME/.local/bin/nvim.appimage"
ln -s "$HOME/.local/bin/nvim.appimage" "$HOME/.local/bin/nvim"
