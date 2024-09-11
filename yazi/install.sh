#!/bin/sh

# docs:
# https://yazi-rs.github.io/docs/configuration/overview

# avoid 'ya' not being run because not in PATH.
export PATH="$PATH:$HOME/.local/bin"

mkdir -p "$HOME/.config/yazi/plugins"
mkdir -p "$HOME/.config/yazi/flavors"

# symlink code overrides and extensions
ln -s "$HOME/dotfiles/yazi/init.lua"  "$HOME/.config/yazi/init.lua"

# symlink config
ln -s "$HOME/dotfiles/yazi/yazi.toml"  "$HOME/.config/yazi/yazi.toml"
ln -s "$HOME/dotfiles/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
ln -s "$HOME/dotfiles/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

# symlink plugins not installed via 'ya' cli tool
ln -s "$HOME/dotfiles/yazi/plugins/smart-enter.yazi" "$HOME/.config/yazi/plugins/smart-enter.yazi"

# clone tokyo-night theme
git clone https://github.com/BennyOe/tokyo-night.yazi.git \
	"$HOME/.config/yazi/flavors/tokyo-night.yazi"

# check install of ya CLI tool
if ! command -v ya > /dev/null
then
    echo "'ya' is not installed. skipping installation of additional extensions."
    exit 1
fi

echo "Installing yazi plugins via ya tool"
# ya clones and checks out in detached state.
# plugins names are actually repo/owner on github,
# e.g. 'https://github.com/' + NAME + '.yazi'
ya pack -a 'yazi-rs/plugins:chmod'
ya pack -a 'yazi-rs/plugins:diff'
ya pack -a 'yazi-rs/plugins:hide-preview'
ya pack -a 'yazi-rs/plugins:max-preview'
ya pack -a 'yazi-rs/plugins:smart-filter'
ya pack -a 'Reledia/glow'
ya pack -a 'KKV9/command'
ya pack -a 'pirafrank/what-size'
ya pack -a 'Ape/open-with-cmd'
ya pack -a 'yazi-rs/plugins:git'
ya pack -a 'AnirudhG07/custom-shell'

echo "Listing install plugins..."
ya pack --list

echo "Done."

