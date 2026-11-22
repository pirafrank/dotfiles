#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
config_source="$script_dir/config.toml"
config_directory="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
config_destination="$config_directory/config.toml"

if [ ! -f "$config_source" ]; then
    printf 'Herdr config not found: %s\n' "$config_source" >&2
    exit 1
fi

mkdir -p "$config_directory"

if [ -L "$config_destination" ]; then
    existing_target=$(readlink "$config_destination")
    case "$existing_target" in
        /*) ;;
        *) existing_target="$(dirname -- "$config_destination")/$existing_target" ;;
    esac
    if [ "$existing_target" = "$config_source" ]; then
        printf 'Herdr config symlink already points to %s\n' "$config_source"
        exit 0
    fi
fi

if [ -e "$config_destination" ] || [ -L "$config_destination" ]; then
    timestamp=$(date '+%Y%m%d-%H%M%S')
    backup_path="$config_destination.$timestamp.bak"
    mv -- "$config_destination" "$backup_path"
    printf 'Existing config backed up to %s\n' "$backup_path"
fi

ln -s "$config_source" "$config_destination"
printf 'Linked %s to %s\n' "$config_destination" "$config_source"

