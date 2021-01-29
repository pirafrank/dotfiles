#!/bin/bash

if [ ! -f /etc/debian_version ]; then
  echo "Sorry, unsupported OS. Only Debian and its derivatives at this time."
  exit 1
fi

# checking for rust to be installed
if [ ! $(command -v rustup) ]; then
  echo "Sorry, rust and cargo are required."
  exit 1
fi

# installing via cargo
cargo install alacritty

# reloading shell
source ~/.zshrc

# install terminfo file
wget "https://github.com/alacritty/alacritty/releases/download/v$(alacritty --version)/alacritty.info"
sudo mkdir -p /usr/share/terminfo/a
sudo mv alacritty.info /usr/share/terminfo/a/alacritty

# install icon
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/compat/alacritty-term%2Bscanlines.png -O ~/.local/share/icons/alacritty.png

# installing desktop shortcut
cat <<EOF > ~/.local/share/applications/alacritty.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Alacritty
GenericName=Terminal emulator
Comment=A cross-platform, OpenGL terminal emulator
TryExec=/home/francesco/.cargo/bin/alacritty
Exec=/home/francesco/.cargo/bin/alacritty
Icon=/home/francesco/.local/share/icons/alacritty.png
Categories=System;TerminalEmulator;
Terminal=false
EOF
# setting correct HOME path
sed -i "s@/home/francesco@${HOME}@g" ~/.local/share/applications/alacritty.desktop

# symlink configuration
ln -sf "$HOME/dotfiles/gui_terminals/alacritty/alacritty_$(uname -s).yml" $HOME/.alacritty.yml

