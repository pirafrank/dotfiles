#!/usr/bin/env bash
set -euo pipefail

PI_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODE="sync"
if [[ "${1:-}" == "--check" ]]; then MODE="check"; elif [[ -n "${1:-}" ]]; then echo "Usage: $0 [--check]" >&2; exit 2; fi
command -v node >/dev/null || { echo "node is required" >&2; exit 1; }
command -v pi >/dev/null || { echo "Pi CLI is required" >&2; exit 1; }
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
