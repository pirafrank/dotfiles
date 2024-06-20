#!/usr/bin/env bash

mkdir -p $HOME/.config/xplr
ln -s $HOME/dotfiles/xplr/init.lua $HOME/.config/xplr/init.lua
ln -s $HOME/dotfiles/xplr/plugins.lua $HOME/.config/xplr/plugins.lua
lua clone_plugins.lua

