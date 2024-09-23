#!/bin/bash

if ! command -v yq2 &> /dev/null; then
    echo "Installing yq2..."
else
    echo "yq2 already installed"
    exit 0
fi

mkdir -p /tmp/yq2_install
cd /tmp/yq2_install || exit 1

DL_URL="https://github.com/mikefarah/yq/releases/download/2.3.0/yq_linux_amd64"
curl -sSL "$DL_URL" -o yq2

# install by putting it in PATH
mv yq2 "$HOME/.local/bin/yq2"
chmod +x "$HOME/.local/bin/yq2"
