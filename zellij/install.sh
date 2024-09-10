#!/bin/sh

# make plugins dir
mkdir -p ~/.config/zellij/plugins

# note: wget -O overwrites the file if it exists

# install zellij-forgot
wget -O ~/.config/zellij/plugins/zellij_forgot.wasm https://github.com/karimould/zellij-forgot/releases/latest/download/zellij_forgot.wasm

# install room
wget -O ~/.config/zellij/plugins/room.wasm https://github.com/rvcas/room/releases/latest/download/room.wasm

# install zellij-jump-list from my fork with built binaries
wget -O ~/.config/zellij/plugins/zellij-jump-list.wasm https://github.com/pirafrank/zellij-jump-list/releases/latest/download/zellij-jump-list.wasm

# install zellij-what-time
wget -O ~/.config/zellij/plugins/zellij-what-time.wasm https://github.com/pirafrank/zellij-what-time/releases/latest/download/zellij-what-time.wasm

# remove execution perms for all plugins as they're loaded by zellij itself
chmod -x ~/.config/zellij/plugins/*

