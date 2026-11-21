#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$CONFIG_HOME/erdtree"
CONFIG_FILE="$CONFIG_DIR/.erdtree.toml"
SOURCE_FILE="$SCRIPT_DIR/.erdtree.toml"

mkdir -p "$CONFIG_DIR"

if [[ -L "$CONFIG_FILE" && "$(readlink "$CONFIG_FILE")" == "$SOURCE_FILE" ]]; then
  echo "erdtree config already linked: $CONFIG_FILE"
  exit 0
fi

if [[ -e "$CONFIG_FILE" || -L "$CONFIG_FILE" ]]; then
  BACKUP_FILE="$CONFIG_FILE.backup-$(date +%Y%m%d%H%M%S)"
  mv -- "$CONFIG_FILE" "$BACKUP_FILE"
  echo "Backed up existing config to: $BACKUP_FILE"
fi

ln -s "$SOURCE_FILE" "$CONFIG_FILE"
echo "Linked erdtree config: $CONFIG_FILE"
