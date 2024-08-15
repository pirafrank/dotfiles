#!/bin/sh

# make plugins dir
mkdir -p ~/.config/zellij/plugins

# install zellij-forgot
wget -O ~/.config/zellij/plugins/zellij_forgot.wasm https://github.com/karimould/zellij-forgot/releases/download/0.4.0/zellij_forgot.wasm

# install room
wget -O ~/.config/zellij/plugins/room.wasm https://github.com/rvcas/room/releases/download/v1.0.1/room.wasm

# install zellij-jump-list
(
    mkdir -p ~/.local/src
    git clone https://github.com/blank2121/zellij-jump-list.git ~/.local/src/zellij-jump-list
    cd ~/.local/src/zellij-jump-list || exit 1
    rustup target add wasm32-wasi
    cargo build --release
    cp -a ./target/wasm32-wasi/release/zellij-jump-list.wasm ~/.config/zellij/plugins/zellij-jump-list.wasm
)

# remove execution perms for all plugins as they're loaded by zellij itself
chmod -x ~/.config/zellij/plugins/*

