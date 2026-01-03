#!/bin/sh

# docs:
# https://yazi-rs.github.io/docs/cli/#pm

# avoid 'ya' not being run because not in PATH.
export PATH="$PATH:$HOME/.local/bin"

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
ya pkg add 'yazi-rs/plugins:chmod'
ya pkg add 'yazi-rs/plugins:diff'
ya pkg add 'yazi-rs/plugins:hide-preview'
ya pkg add 'yazi-rs/plugins:max-preview'
ya pkg add 'yazi-rs/plugins:smart-filter'
ya pkg add 'yazi-rs/plugins:smart-enter'
ya pkg add 'Reledia/glow'
ya pkg add 'KKV9/command'
ya pkg add 'pirafrank/what-size'
ya pkg add 'Ape/open-with-cmd'
ya pkg add 'yazi-rs/plugins:git'
ya pkg add 'AnirudhG07/custom-shell'

echo "Listing installed plugins..."
ya pkg list

echo "Done."

