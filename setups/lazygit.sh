#!/bin/bash

if ! command -v lazygit &> /dev/null; then
    echo "Installing lazygit..."
else
    echo "lazygit already installed"
    exit 0
fi

mkdir -p /tmp/lazygit_install
cd /tmp/lazygit_install || exit 1


DL_URL="$(curl -sSL 'https://api.github.com/repos/jesseduffield/lazygit/releases/latest' \
| grep browser_download_url \
| grep 'Linux_x86_64.tar.gz' \
| cut -d'"' -f4)"

curl -sSL "$DL_URL" -o lazygit.tar.gz
tar -xzf lazygit.tar.gz

# install by putting it in PATH
mv lazygit "$HOME/.local/bin/lazygit"
chmod +x "$HOME/.local/bin/lazygit"
