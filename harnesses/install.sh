#!/usr/bin/env bash
set -euo pipefail

HARNESS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SKILLS_SRC:-$HOME/.local/share/skills}"
SYNC_PI=0

[[ "${1:-}" == "--sync-pi" ]] && SYNC_PI=1
[[ -z "${1:-}" || "${1:-}" == "--sync-pi" ]] || { echo "Usage: $0 [--sync-pi]" >&2; exit 2; }

[[ -d "$SKILLS_SRC" ]] || { echo "Skills source is missing: $SKILLS_SRC" >&2; exit 1; }

link_owned() {
  local source="$1" destination="$2"
  if [[ -e "$destination" && ! -L "$destination" ]]; then
    echo "Refusing to replace non-symlink: $destination" >&2
    return 1
  fi
  mkdir -p "$(dirname "$destination")"
  ln -sfnT "$source" "$destination"
}

# Populate the skills and resources directories with symlinks to the source skills and resources
mkdir -p "$HOME/.agents/skills" "$HOME/.pi/agent" "$HOME/.codex"
for skill in "$SKILLS_SRC"/skills/*; do
  [[ -d "$skill" ]] || continue
  link_owned "$skill" "$HOME/.agents/skills/$(basename "$skill")"
done
for resource in AGENTS.md roles policies profiles workflows prompts; do
  [[ -e "$SKILLS_SRC/$resource" ]] || continue
  link_owned "$SKILLS_SRC/$resource" "$HOME/.agents/$resource"
done

# Codex harness specific links
link_owned "$HOME/.agents/roles" "$HOME/.codex/roles"
link_owned "$SKILLS_SRC/AGENTS.md" "$HOME/.codex/AGENTS.md"

# Pi harness specific links
link_owned "$SKILLS_SRC/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
link_owned "$HOME/.agents/skills" "$HOME/.pi/agent/skills"
link_owned "$HOME/.agents/roles" "$HOME/.pi/agent/agents"
link_owned "$HOME/.agents/prompts" "$HOME/.pi/agent/prompts"
link_owned "$HARNESS_DIR/pi/settings.json" "$HOME/.pi/agent/settings.json"
link_owned "$HARNESS_DIR/pi/extensions" "$HOME/.pi/agent/extensions"

if (( SYNC_PI )); then "$HARNESS_DIR/pi/install.sh"; fi
echo "Harness links installed. Run with --sync-pi to install pinned Pi harness dependencies and approved packages."
