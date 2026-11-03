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

Pi 1.5.0 requires Node.js 22.19.0 or newer. The local SDK is pinned to 1.5.0;
keep the installed CLI aligned with it. The default model is
`openai-codex/gpt-6.1-sol`, and codemode is enabled alongside the default tools.

[`pi/packages.lock.json`](pi/packages.lock.json) is the authoritative package
allowlist. It pins the four approved non-MCP packages;
`settings.json` must match it exactly. The installer checks parity before making
changes and accepts exact scoped npm specifications. Package pinning does not
establish compatibility of third-party extensions; verify them interactively.
Feynman 0.5.62 and pi-web-access 0.46.0 replace the older packages that triggered
Pi 1.5 host-dependency warnings and Feynman's built-in `/thinking` command conflict.

Use Pi's native MCP configuration in `~/.pi/agent/mcp.json` (or trusted project
`.pi/mcp.json`). The adapter is no longer declared. Existing package caches are
left in place; no user-level MCP server definitions were present during migration.
Keep credentials and machine-specific server configuration outside this repository.

Delegation validates the final JSONL assistant response against the portable
`schemas/node-result.schema.json` adjacent to the linked roles directory. Invalid,
failed, aborted, and timed-out responses fail the node. Role tool declarations
restrict the child's built-in tools; absent declarations use the built-in coding
tools. Delegates disable MCP and recursive harness tools, append to Pi's system
prompt, and retain permission gates. Unknown tools and protected operations require
confirmation and are blocked in non-interactive delegates. These gates are not an
OS sandbox; third-party extension internals and shell programs remain trusted code.

Graphs pass structured direct-predecessor results to each dependent node. State
is saved at pending, running, completion, and failure transitions, with atomic
state-file replacement. This supports inspection after interruption, not automatic
resume or replay. Delegate transcripts are bounded to 64 KiB, JSONL records to
1 MiB; timeout or cancellation terminates the process group and escalates to kill.

Skills and prompts use Pi's conventional discovery directories installed below.
`lastChangelogVersion` is omitted from the portable settings, though Pi can write
runtime state back through the existing settings symlink.

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
./install.sh --target pi --sync-pi
```

Use `pi/install.sh --check` to validate the approved package manifest without
installing packages. Keep credentials, Pi authentication, sessions, trust state,
caches, `node_modules`, and graph-run data outside both repositories.

## Verify the Pi setup

From the repository root, check the installed Pi packages and resource loading:

```bash
npm --prefix harnesses/pi run check:setup
```

From the repository root, run TypeScript checks, the regression suite, package
manifest parity validation, and installed user-level resource loading:

```bash
npm --prefix harnesses/pi run check && npm --prefix harnesses/pi test && bash harnesses/pi/install.sh --check && npm --prefix harnesses/pi run check:setup
```

Check the installed CLI version, configured model availability, declared packages,
and native MCP connections separately:

```bash
pi --version
pi --list-models gpt-6.1-sol
pi list
pi mcp list
```

Expect CLI version `1.5.0`, the configured model in the catalog, the four pinned
packages, and any machine-configured MCP servers (an empty server list is valid).
`check:setup` requires the configured packages to be installed at their pinned
versions. It fails on resource-loading errors, warnings, or built-in command
conflicts; it does not run session-start hooks or make a model request.
Start `pi` for interactive skill,
delegation, graph, and permission smoke tests.
