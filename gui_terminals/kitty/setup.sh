#!/bin/bash

if [[ $(uname) != 'Linux' ]]; then
  echo "Sorry, linux only for now"
  exit(1)
fi

# install
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# symlink exec
ln -s $HOME/.local/kitty.app/bin/kitty $HOME/bin2/kitty

# symlink config
ln -s $HOME/dotfiles/gui_terminals/kitty $HOME/.config/kitty

# create desktop shortcut
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=kitty
GenericName=Terminal emulator
Comment=A fast, feature full, GPU based terminal emulator
TryExec=/home/$(whoami)/.local/kitty.app/bin/kitty
Exec=/home/$(whoami)/.local/kitty.app/bin/kitty --config /home/$(whoami)/dotfiles/gui_terminals/kitty/kitty.conf
Icon=/home/$(whoami)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
Categories=System;TerminalEmulator;
Terminal=false" > $HOME/.local/share/application/kitty.desktop

