#!/bin/bash

if ! command -v bat &> /dev/null; then
    echo "Installing bat..."
else
    echo "bat is already installed."
    exit 0
fi

mkdir -p /tmp/bat_install
cd /tmp/bat_install || exit 1

DL_URL="$(curl -sSL 'https://api.github.com/repos/sharkdp/bat/releases/latest' \
| grep browser_download_url \
| grep 'x86_64-unknown-linux-gnu.tar.gz' \
| cut -d'"' -f4)"

curl -sSL "$DL_URL" -o bat.tar.gz
tar -xzf bat.tar.gz

# install by putting it in PATH
mv bat*/bat "$HOME/.local/bin/bat"
chmod +x "$HOME/.local/bin/bat"
