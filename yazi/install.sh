#!/bin/sh

# docs:
# https://yazi-rs.github.io/docs/configuration/overview

mkdir -p "$HOME/.config/yazi/plugins"
mkdir -p "$HOME/.config/yazi/flavors"

# symlink code overrides and extensions
ln -s "$HOME/dotfiles/yazi/init.lua"  "$HOME/.config/yazi/init.lua"

# symlink config
ln -s "$HOME/dotfiles/yazi/yazi.toml"  "$HOME/.config/yazi/yazi.toml"
ln -s "$HOME/dotfiles/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
ln -s "$HOME/dotfiles/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

# clone tokyo-night theme
git clone https://github.com/BennyOe/tokyo-night.yazi.git \
	"$HOME/.config/yazi/flavors/tokyo-night.yazi"

echo "Done."

