#!/bin/bash

# jenv install
if [ -d ~/.jenv ]; then
    echo "jenv already installed"
else
    echo "Installing jenv..."
    git clone https://github.com/jenv/jenv.git ~/.jenv
fi


# pyenv install
if [ -d ~/.pyenv ]; then
    echo "pyenv already installed"
else
    echo "Installing pyenv..."
    curl https://pyenv.run | bash
fi

# nvm install
if [ -d ~/.nvm ]; then
    echo "nvm already installed"
else
    echo "Installing nvm..."
    set -e
    curl -sSL https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
fi

# goenv
if [ -d ~/.goenv ]; then
    echo "goenv already installed"
else
    echo "Installing goenv..."
    git clone https://github.com/go-nv/goenv.git ~/.goenv
fi

# rvm and Ruby need build tools to be installed. better to use a base image with rvm and ruby pre-installed.

# cargo and rustup are installed as part of the Rust installation feature. No need to do that here.

echo "Development tools installation completed!"
