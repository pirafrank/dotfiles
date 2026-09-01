#!/usr/bin/env bash
set -euo pipefail

HARNESS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# Note: the following assumes you have already run:
#       git clone https://github.com/pirafrank/skills.git ~/.local/share/skills
SKILLS_SRC="${SKILLS_SRC:-$HOME/.local/share/skills}"
SYNC_PI=0
UNINSTALL=0
TARGET=""

usage() {
  cat >&2 <<EOF
Usage: $0 [--target codex|pi|jcode|opencode|universal] [--uninstall] [--sync-pi]
EOF
}

while (($#)); do
  case "$1" in
    --target)
      (($# >= 2)) || { usage; exit 2; }
      TARGET="$2"
      shift 2
      ;;
    --uninstall)
      UNINSTALL=1
      shift
      ;;
    --sync-pi)
      SYNC_PI=1
      shift
      ;;
    -h|--help)
      usage >&1
      exit 0
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

case "$TARGET" in
  "")
    if [[ -t 0 ]]; then
      echo "Select installation target:"
      select TARGET in codex pi jcode opencode universal; do
        [[ -n "$TARGET" ]] && break
        echo "Invalid selection." >&2
      done
    else
      TARGET=universal
    fi
    ;;
  codex|pi|jcode|opencode|universal) ;;
  *)
    echo "Invalid target: $TARGET" >&2
    usage
    exit 2
    ;;
esac

if (( SYNC_PI )) && [[ "$TARGET" != pi || $UNINSTALL -eq 1 ]]; then
  echo "--sync-pi is only valid when installing the pi target" >&2
  exit 2
fi

if (( ! UNINSTALL )); then
  [[ -d "$SKILLS_SRC" ]] || { echo "Skills source is missing: $SKILLS_SRC" >&2; exit 1; }
fi

link_owned() {
  local source="$1" destination="$2"
  if [[ -e "$destination" && ! -L "$destination" ]]; then
    echo "Refusing to replace non-symlink: $destination" >&2
    return 1
  fi
  mkdir -p "$(dirname "$destination")"
  ln -sfnT "$source" "$destination"
}

remove_owned() {
  local destination="$1" source
  [[ -L "$destination" ]] || return 0
  source="$(readlink -- "$destination")"
  case "$source" in
    "$SKILLS_SRC"|"$SKILLS_SRC"/*|"$HARNESS_DIR"|"$HARNESS_DIR"/*)
      rm -- "$destination"
      ;;
  esac
}

remove_owned_children() {
  local root="$1" destination
  [[ -d "$root" ]] || return 0
  while IFS= read -r -d '' destination; do
    remove_owned "$destination"
  done < <(find -P "$root" -mindepth 1 -type l -print0)
}

install_universal() {
  mkdir -p "$HOME/.agents/skills"
  for skill in "$SKILLS_SRC"/skills/*; do
    [[ -d "$skill" ]] || continue
    link_owned "$skill" "$HOME/.agents/skills/$(basename "$skill")"
  done
  for resource in AGENTS.md roles policies profiles workflows prompts; do
    [[ -e "$SKILLS_SRC/$resource" ]] || continue
    link_owned "$SKILLS_SRC/$resource" "$HOME/.agents/$resource"
  done
}

install_harness() {
  local root="$1"
  mkdir -p "$root/skills"
  for skill in "$SKILLS_SRC"/skills/*; do
    [[ -d "$skill" ]] || continue
    link_owned "$skill" "$root/skills/$(basename "$skill")"
  done
  [[ -e "$SKILLS_SRC/AGENTS.md" ]] && link_owned "$SKILLS_SRC/AGENTS.md" "$root/AGENTS.md"
  [[ -e "$SKILLS_SRC/roles" ]] && link_owned "$SKILLS_SRC/roles" "$root/roles"
}

uninstall_universal() {
  remove_owned_children "$HOME/.agents/skills"
  for resource in AGENTS.md roles policies profiles workflows prompts; do
    remove_owned "$HOME/.agents/$resource"
  done
}

uninstall_harness() {
  local root="$1"
  remove_owned_children "$root/skills"
  remove_owned "$root/AGENTS.md"
  remove_owned "$root/roles"
}

if (( UNINSTALL )); then
  case "$TARGET" in
    universal) uninstall_universal ;;
    codex) uninstall_harness "$HOME/.codex" ;;
    pi)
      uninstall_harness "$HOME/.pi/agent"
      remove_owned "$HOME/.pi/agent/agents"
      remove_owned "$HOME/.pi/agent/prompts"
      remove_owned "$HOME/.pi/agent/settings.json"
      remove_owned "$HOME/.pi/agent/extensions"
      ;;
    jcode) uninstall_harness "$HOME/.jcode" ;;
    opencode) uninstall_harness "$HOME/.config/opencode" ;;
  esac
  echo "Harness links uninstalled for $TARGET."
  exit 0
fi

case "$TARGET" in
  universal) install_universal ;;
  codex) install_harness "$HOME/.codex" ;;
  pi)
    install_harness "$HOME/.pi/agent"
    link_owned "$SKILLS_SRC/roles" "$HOME/.pi/agent/agents"
    link_owned "$SKILLS_SRC/prompts" "$HOME/.pi/agent/prompts"
    link_owned "$HARNESS_DIR/pi/settings.json" "$HOME/.pi/agent/settings.json"
    link_owned "$HARNESS_DIR/pi/extensions" "$HOME/.pi/agent/extensions"
    ;;
  jcode) install_harness "$HOME/.jcode" ;;
  opencode) install_harness "$HOME/.config/opencode" ;;
esac

if (( SYNC_PI )); then "$HARNESS_DIR/pi/install.sh"; fi
echo "Harness links installed for $TARGET. Run with --target pi --sync-pi to install pinned Pi harness dependencies and approved packages."
