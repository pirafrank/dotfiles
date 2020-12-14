#!/bin/bash

if [ $(uname) != 'Linux' ] && [ $(uname) != 'Darwin' ];
  echo "Sorry, unsupported OS. Only Linux and macOS for now."
  exit(1)
fi

# install using your distro package manager on Linux
# and by downloading prebuilt binaries on macOS and Windows

# symlink configuration
ln -s $HOME/dotfiles/gui_terminals/alacritty/alacritty.yml $HOME/.alacritty.yml

