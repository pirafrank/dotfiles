#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source-node-version> <target-node-version>" >&2
  exit 2
fi

source_version=$1
target_version=$2

if ! command -v nvm >/dev/null 2>&1; then
  echo "Error: nvm is not available in this shell." >&2
  echo "Run this script from a shell where nvm is initialized." >&2
  exit 1
fi

package_list=$(mktemp)
target_packages=$(mktemp)
trap 'rm -f "$package_list" "$target_packages"' EXIT

# Capture exact package versions while the source Node.js version is active.
nvm use "$source_version" >/dev/null
npm list --global --depth=0 --json | node -e '
  let input = "";
  process.stdin.on("data", chunk => input += chunk);
  process.stdin.on("end", () => {
    const { dependencies = {} } = JSON.parse(input);
    for (const [name, details] of Object.entries(dependencies)) {
      if (name === "npm" || name === "corepack") continue;
      if (details.version) console.log(`${name}@${details.version}`);
    }
  });
' > "$package_list"

if [[ ! -s $package_list ]]; then
  echo "No packages to migrate."
  exit 0
fi

# Switch versions only after the package list is safely captured.
nvm use "$target_version" >/dev/null
npm list --global --depth=0 --json | node -e '
  let input = "";
  process.stdin.on("data", chunk => input += chunk);
  process.stdin.on("end", () => {
    const { dependencies = {} } = JSON.parse(input);
    for (const name of Object.keys(dependencies)) console.log(name);
  });
' > "$target_packages"

# Install only packages missing from the target, at their source versions.
while IFS= read -r package; do
  package_name=${package%@*}
  if grep -Fxq -- "$package_name" "$target_packages"; then
    echo "Skipping $package_name; it is already installed for Node.js $target_version."
    continue
  fi
  npm install --global "$package"
done < "$package_list"
