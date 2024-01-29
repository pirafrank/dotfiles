#!/bin/bash

mkdir -p /tmp/lazygit_install
cd /tmp/lazygit_install


DL_URL="$(curl -sSL 'https://api.github.com/repos/jesseduffield/lazygit/releases/latest' \
| grep browser_download_url \
| grep 'Linux_x86_64.tar.gz' \
| cut -d'"' -f4)"

curl -sSL $DL_URL -o lazygit.tar.gz
tar -xzf lazygit.tar.gz

# install by putting it in PATH
mv lazygit "$HOME/bin2/lazygit"
chmod +x "$HOME/bin2/lazygit"
