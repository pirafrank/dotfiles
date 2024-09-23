#!/bin/bash

if ! command -v yazi &> /dev/null; then
    echo "Installing yazi..."
else
    echo "yazi already installed"
    exit 0
fi

mkdir -p /tmp/yazi_install
cd /tmp/yazi_install || exit 1


DL_URL="$(curl -sSL 'https://api.github.com/repos/sxyazi/yazi/releases/latest' \
| grep browser_download_url \
| grep 'x86_64-unknown-linux-gnu.zip' \
| cut -d'"' -f4)"

curl -sSL "$DL_URL" -o yazi.zip
unzip yazi.zip

# install by putting it in PATH
mv yazi*/yazi "$HOME/.local/bin/yazi"
chmod +x "$HOME/.local/bin/yazi"

mv yazi*/ya "$HOME/.local/bin/ya"
chmod +x "$HOME/.local/bin/ya"
