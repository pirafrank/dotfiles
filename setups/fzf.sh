#!/bin/bash

# installing fzf
if [ -d ~/.fzf ]; then
    echo "fzf already installed"
else
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
    ~/.fzf/install --bin
fi
