#!/bin/bash

if ! command -v delta &> /dev/null; then
    echo "Installing delta..."
else
    echo "delta is already installed."
    exit 0
fi

mkdir -p /tmp/delta_install
cd /tmp/delta_install || exit 1


DL_URL="$(curl -sSL 'https://api.github.com/repos/dandavison/delta/releases/latest' \
| grep browser_download_url \
| grep 'x86_64-unknown-linux-gnu.tar.gz' \
| cut -d'"' -f4)"

curl -sSL "$DL_URL" -o delta.tar.gz
tar -xzf delta.tar.gz

# install by putting it in PATH
mv delta*/delta "$HOME/.local/bin/delta"
chmod +x "$HOME/.local/bin/delta"
