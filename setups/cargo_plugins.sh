#!/bin/sh

if ! command -v cargo > /dev/null; then
    echo "cargo is not installed. Install cargo first. Aborting."
    exit 1
else
    echo "Installing cargo plugins..."
fi

cargo install cargo-edit
cargo install cargo-binstall
cargo install cargo-update
cargo install cargo-msrv
cargo install cargo-chef
cargo install cargo-deny
cargo install cargo-get
cargo install cargo-semver-checks --locked
cargo install cargo-outdated --locked

