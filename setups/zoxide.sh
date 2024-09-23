#!/bin/bash

if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
else
    echo "zoxide already installed"
    exit 0
fi

# installing fzf
if [ -d ~/.local/bin/zoxide ]; then
    echo "zoxide already installed"
else
    echo "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi
