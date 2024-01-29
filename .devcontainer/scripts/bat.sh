#!/bin/bash

mkdir -p /tmp/bat_install
cd /tmp/bat_install

DL_URL="$(curl -sSL 'https://api.github.com/repos/sharkdp/bat/releases/latest' \
| grep browser_download_url \
| grep 'x86_64-unknown-linux-gnu.tar.gz' \
| cut -d'"' -f4)"

curl -sSL $DL_URL -o bat.tar.gz
tar -xzf bat.tar.gz

# install by putting it in PATH
mv bat*/bat "$HOME/bin2/bat"
chmod +x "$HOME/bin2/bat"
