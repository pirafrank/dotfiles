#!/bin/bash

if [ $(uname) != 'Linux' ] && [ $(uname) != 'Darwin' ];
  echo "Sorry, unsupported OS. Only Linux and macOS for now."
  exit(1)
fi

# install using your distro package manager on Linux
# and by downloading prebuilt binaries on macOS and Windows

# symlink configuration
ln -sf "$HOME/dotfiles/gui_terminals/alacritty/alacritty_$(uname -s).yml" $HOME/.alacritty.yml
