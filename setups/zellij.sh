#!/bin/bash

if ! command -v zellij &> /dev/null; then
    echo "Installing zellij..."
else
    echo "zellij already installed"
    exit 0
fi

mkdir -p /tmp/zellij_install
cd /tmp/zellij_install || exit 1

DL_URL="https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"

curl -sSL "$DL_URL" -o zellij.tar.gz
tar -xzf zellij.tar.gz

# install by putting it in PATH
mv zellij "$HOME/.local/bin/zellij"
chmod +x "$HOME/.local/bin/zellij"
