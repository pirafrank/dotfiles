#!/usr/bin/env bash

set -Eeuo pipefail

# Install the Nushell configuration from this repository.  Existing targets
# are preserved as <name>.YYYY-MM-DD_HHmmss.bkp before linking.
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$DOTFILES_DIR/nushell"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nushell"
TIMESTAMP="$(date '+%Y-%m-%d_%H%M%S')"

backup_target() {
    local target="$1"
    local backup="${target}.${TIMESTAMP}.bkp"

    if [[ -e "$backup" || -L "$backup" ]]; then
        local counter=1
        while [[ -e "${target}.${TIMESTAMP}_${counter}.bkp" || -L "${target}.${TIMESTAMP}_${counter}.bkp" ]]; do
            counter=$((counter + 1))
        done
        backup="${target}.${TIMESTAMP}_${counter}.bkp"
    fi

    printf 'Backing up %s -> %s\n' "$target" "$backup"
    mv -- "$target" "$backup"
}

install_link() {
    local source="$1"
    local target="$2"

    if [[ -L "$target" && "$(readlink -- "$target")" == "$source" ]]; then
        printf 'Already linked: %s\n' "$target"
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        backup_target "$target"
    fi

    printf 'Linking %s -> %s\n' "$target" "$source"
    ln -s -- "$source" "$target"
}

if [[ ! -f "$SOURCE_DIR/env.nu" || ! -f "$SOURCE_DIR/config.nu" ]]; then
    printf 'Nushell configuration files were not found below %s\n' "$SOURCE_DIR" >&2
    exit 1
fi

mkdir -p "$CONFIG_DIR"
install_link "$SOURCE_DIR/env.nu" "$CONFIG_DIR/env.nu"
install_link "$SOURCE_DIR/config.nu" "$CONFIG_DIR/config.nu"

printf '\nNushell configuration installed.\n'
printf 'Config directory: %s\n' "$CONFIG_DIR"
printf 'Reload Nushell with: source $nu.config-path\n'
