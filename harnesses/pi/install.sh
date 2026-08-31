#!/usr/bin/env bash
set -euo pipefail

PI_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODE="sync"
if [[ "${1:-}" == "--check" ]]; then MODE="check"; elif [[ -n "${1:-}" ]]; then echo "Usage: $0 [--check]" >&2; exit 2; fi
command -v node >/dev/null || { echo "node is required" >&2; exit 1; }
command -v pi >/dev/null || { echo "Pi CLI is required" >&2; exit 1; }
if [[ "$MODE" == "sync" ]]; then npm --prefix "$PI_DIR" ci; fi
node --input-type=module - "$PI_DIR/packages.lock.json" "$MODE" <<'NODE'
import { readFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
const [lockPath, mode] = process.argv.slice(-2);
const lock = JSON.parse(readFileSync(lockPath, "utf8"));
if (lock.version !== 1 || !Array.isArray(lock.packages)) throw new Error("invalid packages.lock.json");
for (const spec of lock.packages) {
  if (typeof spec !== "string" || !/^npm:[^@]+@\d+\.\d+\.\d+/.test(spec)) throw new Error(`package must be exact: ${spec}`);
  if (mode === "check") { console.log(`approved package: ${spec}`); continue; }
  const result = spawnSync("pi", ["install", spec], { stdio: "inherit" });
  if (result.status !== 0) process.exit(result.status ?? 1);
}
console.log(lock.packages.length === 0 ? "No third-party Pi packages are approved." : "Pi package parity complete.");
NODE
