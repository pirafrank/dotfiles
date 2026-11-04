# Pi harness

This directory contains the machine-specific Pi settings, owned extensions,
pinned Node dependencies, approved package allowlist, and installer.

## Setup

Pi 1.5.0 requires Node.js 22.19.0 or newer. Install the Pi CLI at version
1.5.0, and make sure the shared skills checkout exists at
`~/.local/share/skills` (or set `SKILLS_SRC` to its path).

From the harness repository root, install the full Pi setup:

```bash
./pi/install.sh
```

This links skills and shared resources into `~/.pi/agent`, links the Pi settings
and extensions from this repository, installs the pinned local dependencies with
`npm ci`, and syncs the packages approved in `packages.lock.json`. The root
`./install.sh --target pi` command delegates to the same installer. Uninstall
owned Pi links with either:

```bash
./pi/install.sh --uninstall
./install.sh --target pi --uninstall
```

`./pi/install.sh --check` validates the approved package manifest and reports
its package specifications without installing them. Keep credentials, Pi
authentication, sessions, trust state, caches, `node_modules`, and graph-run data
outside both repositories.

## Configuration and packages

The default model is `openai-codex/gpt-6.1-sol`; codemode is enabled alongside
the default tools. The local SDK is pinned to 1.5.0, so keep the installed CLI
aligned with it.

[`packages.lock.json`](packages.lock.json) is the authoritative package
allowlist, and `settings.json` must match it exactly. The installer validates
parity before syncing and accepts exact scoped npm specifications. Package
pinning does not establish compatibility of third-party extensions; verify them
interactively. Feynman 0.5.62 and pi-web-access 0.46.0 replace older packages
that triggered Pi 1.5 host-dependency warnings and Feynman's built-in
`/thinking` command conflict.

Use Pi's native MCP configuration in `~/.pi/agent/mcp.json` (or trusted project
`.pi/mcp.json`). The adapter is no longer declared. Keep credentials and
machine-specific server configuration outside this repository.

## Harness behavior

The owned extension layer provides:

- isolated specialist delegation with compact structured results;
- permission gates for destructive, external, install, and ambiguous shell work;
- validated static task graphs with bounded concurrency, retries, persisted run
  state, and a single shared-checkout writer;
- shared role, skill, prompt, and charter discovery from `pirafrank/skills`.

Delegation validates the final JSONL assistant response against
`schemas/node-result.schema.json` adjacent to the linked roles directory.
Invalid, failed, aborted, and timed-out responses fail the node. Role tool
declarations restrict the child's built-in tools; absent declarations use the
built-in coding tools. Delegates disable MCP and recursive harness tools, append
to Pi's system prompt, and retain permission gates. Unknown tools and protected
operations require confirmation and are blocked in non-interactive delegates.
These gates are not an OS sandbox; third-party extension internals and shell
programs remain trusted code.

Graphs pass structured direct-predecessor results to each dependent node. State
is saved at pending, running, completion, and failure transitions, with atomic
state-file replacement. This supports inspection after interruption, not
automatic resume or replay. Delegate transcripts are bounded to 64 KiB, JSONL
records to 1 MiB; timeout or cancellation terminates the process group and
escalates to kill.

Skills and prompts use Pi's conventional discovery directories. The settings file
is linked into the user configuration, so Pi may write runtime changelog state
back into this repository through that link.

## Verification

From this repository root, validate the installed Pi packages and resource
loading:

```bash
npm --prefix pi run check:setup
```

Run static checks, the regression suite, package manifest validation, and
installed user-level resource loading with:

```bash
npm --prefix pi run check
npm --prefix pi test
./pi/install.sh --check
npm --prefix pi run check:setup
```

Check the installed CLI version, configured model availability, declared
packages, and native MCP connections separately:

```bash
pi --version
pi --list-models gpt-6.1-sol
pi list
pi mcp list
```

Expect CLI version `1.5.0`, the configured model in the catalog, the four pinned
packages, and any machine-configured MCP servers (an empty server list is
valid). `check:setup` requires the configured packages to be installed at their
pinned versions. It fails on resource-loading errors, warnings, or built-in
command conflicts; it does not run session-start hooks or make a model request.
Start `pi` for interactive skill, delegation, graph, and permission smoke tests.
