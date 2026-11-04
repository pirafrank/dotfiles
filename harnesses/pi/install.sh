#!/usr/bin/env bash
set -euo pipefail

PI_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_DIR="$(dirname "$PI_DIR")"
SKILLS_SRC="${SKILLS_SRC:-$HOME/.local/share/skills}"
MODE="sync"
UNINSTALL=0

usage() {
  cat >&2 <<EOF
Usage: $0 [--check | --uninstall]
EOF
}

while (($#)); do
  case "$1" in
    --check)
      [[ "$MODE" == sync && $UNINSTALL -eq 0 ]] || { usage; exit 2; }
      MODE=check
      shift
      ;;
    --uninstall)
      [[ "$MODE" == sync && $UNINSTALL -eq 0 ]] || { usage; exit 2; }
      UNINSTALL=1
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

if (( UNINSTALL )); then
  uninstall_root="$HOME/.pi/agent"
  remove_owned_children "$uninstall_root/skills"
  for resource in AGENTS.md roles agents prompts settings.json harness.json extensions; do
    remove_owned "$uninstall_root/$resource"
  done
  echo "Pi harness links uninstalled."
  exit 0
fi

if [[ "$MODE" == sync ]]; then
  [[ -d "$SKILLS_SRC" ]] || { echo "Skills source is missing: $SKILLS_SRC" >&2; exit 1; }
  command -v node >/dev/null || { echo "node is required" >&2; exit 1; }
  command -v npm >/dev/null || { echo "npm is required" >&2; exit 1; }
  command -v pi >/dev/null || { echo "Pi CLI is required" >&2; exit 1; }
  node --input-type=module - "$PI_DIR" <<'NODE'
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";
const directory = process.argv.at(-1);
const { validatePackages } = await import(pathToFileURL(`${directory}/lib/packages.mjs`));
const lock = JSON.parse(readFileSync(`${directory}/packages.lock.json`, "utf8"));
const settings = JSON.parse(readFileSync(`${directory}/settings.json`, "utf8"));
validatePackages(lock, settings);
const [major, minor] = process.versions.node.split(".").map(Number);
if (major < 22 || (major === 22 && minor < 19)) throw new Error("Pi requires Node >=22.19.0");
NODE
  pi_root="$HOME/.pi/agent"
  mkdir -p "$pi_root/skills"
  for skill in "$SKILLS_SRC"/skills/*; do
    [[ -d "$skill" ]] || continue
    link_owned "$skill" "$pi_root/skills/$(basename "$skill")"
  done
  [[ -e "$SKILLS_SRC/AGENTS.md" ]] && link_owned "$SKILLS_SRC/AGENTS.md" "$pi_root/AGENTS.md"
  link_owned "$SKILLS_SRC/roles" "$pi_root/agents"
  link_owned "$SKILLS_SRC/prompts" "$pi_root/prompts"
  link_owned "$PI_DIR/settings.json" "$pi_root/settings.json"
  link_owned "$PI_DIR/harness.json" "$pi_root/harness.json"
  link_owned "$PI_DIR/extensions" "$pi_root/extensions"
fi

node --input-type=module - "$PI_DIR" "$MODE" <<'NODE'
import { readFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { pathToFileURL } from "node:url";
const [directory, mode] = process.argv.slice(-2);
const { validatePackages } = await import(pathToFileURL(`${directory}/lib/packages.mjs`));
const lock = JSON.parse(readFileSync(`${directory}/packages.lock.json`, "utf8"));
const settings = JSON.parse(readFileSync(`${directory}/settings.json`, "utf8"));
const packages = validatePackages(lock, settings);
const [major, minor] = process.versions.node.split(".").map(Number);
if (major < 22 || (major === 22 && minor < 19)) throw new Error("Pi requires Node >=22.19.0");
if (mode === "sync") {
  const result = spawnSync("npm", ["--prefix", directory, "ci"], { stdio: "inherit" });
  if (result.status !== 0) process.exit(result.status ?? 1);
}
for (const spec of packages) {
  if (mode === "check") { console.log(`approved package: ${spec}`); continue; }
  const result = spawnSync("pi", ["install", spec], { stdio: "inherit" });
  if (result.status !== 0) process.exit(result.status ?? 1);
}
console.log(lock.packages.length === 0 ? "No third-party Pi packages are approved." : "Pi package parity complete.");
NODE
