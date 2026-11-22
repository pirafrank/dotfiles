#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_root=${XDG_CONFIG_HOME:-${HOME:?HOME must be set}/.config}

install_file() {
    source=$1
    destination=$2
    destination_dir=$(dirname -- "$destination")

    if [ ! -f "$source" ]; then
        printf 'Herdr config not found: %s\n' "$source" >&2
        exit 1
    fi

    mkdir -p "$destination_dir"
    if [ -f "$destination" ] && cmp -s "$source" "$destination"; then
        printf 'Already installed: %s\n' "$destination"
        return
    fi

    if [ -e "$destination" ] || [ -L "$destination" ]; then
        timestamp=$(date '+%Y%m%d-%H%M%S')
        backup="$destination.$timestamp.bak"
        suffix=1
        while [ -e "$backup" ] || [ -L "$backup" ]; do
            backup="$destination.$timestamp-$suffix.bak"
            suffix=$((suffix + 1))
        done
        mv -- "$destination" "$backup"
        printf 'Backed up existing file to %s\n' "$backup"
    fi

    cp "$source" "$destination"
    printf 'Installed %s\n' "$destination"
}

install_file "$script_dir/core/config.toml" "$config_root/herdr-core/config.toml"
install_file "$script_dir/app/settings.json" "$config_root/herdr-app/settings.json"
install_file "$script_dir/app/keys.json" "$config_root/herdr-app/keys.json"
