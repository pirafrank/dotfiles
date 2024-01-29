#!/bin/bash

mkdir -p /tmp/delta_install
cd /tmp/delta_install


DL_URL="$(curl -sSL 'https://api.github.com/repos/dandavison/delta/releases/latest' \
| grep browser_download_url \
| grep 'x86_64-unknown-linux-gnu.tar.gz' \
| cut -d'"' -f4)"

curl -sSL $DL_URL -o delta.tar.gz
tar -xzf delta.tar.gz

# install by putting it in PATH
mv delta*/delta "$HOME/bin2/delta"
chmod +x "$HOME/bin2/delta"
