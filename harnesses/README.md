# Coding harnesses

Machine-specific installation and runtime configuration for coding agents. This
repository complements, but does not replace,
[pirafrank/skills](https://github.com/pirafrank/skills).

## Separation of concerns

| Repository | Owns | Does not own |
| --- | --- | --- |
| [pirafrank/skills](https://github.com/pirafrank/skills) | Portable Agent Skills, shared `AGENTS.md`, policies, roles, language/domain profiles, workflow templates, and schemas. | Machine credentials, Pi extensions, provider selection, runtime state, or installation side effects. |
| `dotfiles/harnesses` | Runtime installation, discovery links, Pi settings, TypeScript extensions, pinned Node dependencies, approved Pi package parity, and runtime state locations. | Portable engineering behavior or duplicated skills/roles/policies. |

The boundary is deliberate: change reusable agent guidance in `pirafrank/skills`;
change a specific harness or machine integration here. The harness installer reads
the skills checkout from `~/.local/share/skills` and exposes authored skills
through a real `~/.agents/skills` directory, allowing third-party `npx skills
add -g` packages to coexist without modifying the skills working tree.

## Pi harness

[`pi/`](pi/) provides a small owned extension layer rather than a broad external
agent framework:

- isolated specialist delegation with compact structured results;
- permission gates for destructive, external, install, and ambiguous shell work;
- validated static task graphs with bounded concurrency, retries, persisted run
  state, and a single shared-checkout writer;
- shared role, skill, prompt, and charter discovery from `pirafrank/skills`.

No third-party Pi catalog packages are approved for v1. The empty
[`pi/packages.lock.json`](pi/packages.lock.json) is the sole allowlist for any
future exact, reviewed package additions.

## Installation

Run from this directory:

```bash
./install.sh
```

This creates safe source-controlled links only. It never clones or pulls either
repository, replaces a non-symlink target, or removes packages.

To install the pinned local Pi harness dependencies and synchronize every
package explicitly approved in `pi/packages.lock.json`, run:

```bash
./install.sh --sync-pi
```

Use `pi/install.sh --check` to validate the approved package manifest without
installing packages. Keep credentials, Pi authentication, sessions, trust state,
caches, `node_modules`, and graph-run data outside both repositories.
