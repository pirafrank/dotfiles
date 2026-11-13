# Pi harness

This directory contains the machine-specific Pi settings, owned extensions,
goal/workflow configuration, pinned Node dependencies, approved package
allowlist, and installer.

## Pi setup

Pi 1.5.2 requires Node.js 22.19.0 or newer.

It can be installed as managed or unmanaged install. Managed is preferred.
To do so run: `curl -fsSL <https://pi.dev/install.sh> | sh`.

Pi native managed installation will install Pi to `~/.local/bin/pi`, and remove its
npm variant, `npm uninstall -g @earendil-works/pi-coding-agent`, if installed.

## Pi harness setup

Install the Pi CLI at version 1.5.2 or above, and make sure the shared skills
checkout exists at `~/.local/share/skills` (or set `SKILLS_SRC` to its path).

From the harness repository root, install the full Pi setup:

```bash
./pi/install.sh
```

This links skills and shared resources into `~/.pi/agent`, links the Pi settings,
harness model tiers, and extensions from this repository, installs the pinned
local dependencies with `npm ci`, and syncs the packages approved in
`packages.lock.json`. The root
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

Pi's interactive default model is set in `settings.json`; workflow model tiers
and the fixed selector model are set in `harness.json`. Codemode is enabled
alongside the default tools. The local SDK is pinned to 1.5.2, so keep the
installed CLI aligned with it.

The configured physical default is `openai-codex/gpt-6-luna`, set in
[`settings.json`](settings.json):

```json
{
  "defaultProvider": "openai-codex",
  "defaultModel": "gpt-6-luna"
}
```

The `extensions/interactive-router` extension automatically selects `harness/auto`
for eligible new interactive sessions starting from this default. Disabling that
extension leaves new sessions on `openai-codex/gpt-6-luna` directly. Explicit CLI
model choices and restored sessions retain their own selections.

The installed `pi-model-auto` package provides a separate `pi-router/auto` model.
Run `/model pi-router/auto` to use it.
Installing the package does not change the configured default. To make it the
default, set `defaultProvider` to `pi-router` and `defaultModel` to `auto`.
Graph nodes and delegated agents continue using the harness tiers and selector
in `harness.json`.

[`packages.lock.json`](packages.lock.json) is the authoritative package
allowlist, and the package sources in `settings.json` must match it exactly. The installer validates
parity before syncing and accepts exact scoped npm specifications. Package
pinning does not establish compatibility of third-party extensions; verify them
interactively. Feynman 0.5.62 and pi-web-access 0.46.0 replace older packages
that triggered Pi 1.5 host-dependency warnings and Feynman's built-in
`/thinking` command conflict.

Configure user-level MCP servers in `~/.pi/agent/mcp.json`. Pi also supports
project-level configuration in `.pi/mcp.json` for trusted projects. The adapter
is no longer declared. Keep credentials and machine-specific server
configuration outside this repository.

## Harness behavior

### Interactive virtual model

Select `/model harness/auto` for per-prompt routing through the tiers and selector
in `harness.json`. New interactive sessions starting from the configured physical
default select it automatically. Explicit CLI choices and restored sessions retain
their selections. Delegates keep their physical default and workflow routing.

Classification failures fall back to medium; model-selection failures use the
first available candidate in the selected tier. If that tier has no available
models, routing reports an error. Tool continuations, retries, and compaction
retain the previous physical model. Selection adds up to two selector requests
per user turn. Pi displays the physical model in its footer and transcript.
Provider failures follow Pi's normal retry behavior.

### Command aliases

Edit [`extensions/aliases/aliases.json`](extensions/aliases/aliases.json) to map
existing Pi command names to aliases, without leading slashes. The initial
`{"quit": "exit"}` entry makes both `exit` and `/exit` run `/quit` in the
interactive editor. For example, adding `"model": "m"` enables `/m` (or `m`)
and forwards any arguments to `/model`. Use `/reload` after editing the JSON.
Aliases expand once, before Pi dispatches commands, and work with built-in and
extension commands. Existing editor customizations are preserved when the alias
extension loads; another extension that later replaces the editor may override it.

The owned extension layer provides:

- isolated specialist delegation with compact structured results;
- permission gates for destructive, external, install, and ambiguous shell work;
- goal planning through the configured planner tier, with `pi-goal` managing
  session-scoped goal state and guarded continuation;
- validated dependency graphs and bounded routed workflows, tier-constrained
  model selection, structured outcomes, persisted run state, and run-by-ID resume;
- bounded edit/review loops, deterministic outcome branches, and a constrained
  model route decision only when graph conditions leave no single route;
- shared role, skill, prompt, and charter discovery from `pirafrank/skills`.

Direct delegation validates the final JSONL assistant response against
`schemas/node-result.schema.json` adjacent to the linked roles directory. Graph
tasks use the harness-owned `schemas/workflow-result.schema.json`, which adds
structured decisions, findings, and evidence. `harness.json` maps agent roles to
homogeneous capability tiers and lists the Pi model IDs allowed in each tier.
The selector chooses only among models in the assigned tier. Provider failures
fall back through that tier's candidates; model choices and failures are saved
with the run.
Invalid, failed, aborted, and timed-out responses fail the node. Role tool
declarations restrict the child's built-in tools; absent declarations use the
built-in coding tools. Delegates disable MCP and recursive harness tools, append
to Pi's system prompt, and retain permission gates. Unknown tools and protected
operations require confirmation and are blocked in non-interactive delegates.
These gates are not an OS sandbox; third-party extension internals and shell
programs remain trusted code.

The default `scoped` permission policy allows local shell commands joined by
`;`, `&&`, `||`, newlines, and pipes, including `2>&1` and file redirections
inside the allowed roots. Each command, redirection, and `cd` target is checked
against the session's current directory and `/add-dir` roots. Directory changes
do not add new trusted roots. Credentials, paths outside those roots, protected
Git/package operations, and unsupported shell syntax still require confirmation.
Trusted Pi resource directories permit reads only. Use `/reload` to load updated
extension code in a running Pi session.

Graphs pass structured predecessor results to dependent nodes. Existing DAGs
retain bounded concurrency and a single shared-checkout writer. Routed graphs
run one selected path at a time, use declared outcome conditions first, and
allow only acyclic route edges; iterative edit/review work uses a bounded
`review_loop` node (at most three passes). State is saved at pending, running,
progress, completion, and failure transitions with atomic state-file
replacement. Use `graph_status({runId})` to inspect a saved run and
`graph_resume({runId})` to continue it; completed nodes are retained and
interrupted nodes rerun only when the saved graph and model-tier configuration
hashes still match. Delegate transcripts are bounded to 64 KiB, JSONL records
to 1 MiB; timeout or cancellation terminates the process group and escalates to
kill.

Skills and prompts use Pi's conventional discovery directories. The settings and
harness configuration are linked into the user configuration, so Pi may write
runtime changelog state back into this repository through the settings link.

## Verification

### Contracts, checkpoints, and human approval

Every `graph_run` requires a JSON `contract` string validated against both the
installed skills repository's `schemas/task-contract.schema.json` and this
harness's `schemas/task-execution.schema.json`. For example:

```json
{
  "goal": "Fix the parser regression",
  "repository": "/absolute/path/to/repository",
  "baseSha": "REPLACE_WITH_FULL_GIT_HEAD_SHA",
  "acceptanceCriteria": ["The regression test passes"],
  "writeAllowed": ["src/**", "tests/**"],
  "writeForbidden": ["AGENTS.md", ".github/**"],
  "approvalGates": { "scope": true, "completion": true }
}
```

The repository must be the Git root and `baseSha` its current HEAD. Criteria
must exactly match the graph. Optional write rules accept exact paths,
`directory/**`, or `**`; an empty `writeAllowed` permits no source changes.
Omitting write rules leaves file scope unrestricted within the approved goal.
Scope checks detect changes after execution; they do not sandbox shell commands.

Use `graph_plan` to create a goal graph, then inspect its criteria and supply
the matching contract to `graph_run({name, contract})`. For shared templates,
use `graph_create({graph: "feature", acceptanceCriteria: [...]})` first.
Templates resolve alongside the installed roles directory, so a separate
`~/.agents/workflows` link is unnecessary. Pi adapts portable templates into
sequential routes in dependency order; a review must accept before continuing.
Templates without a verifier stop for human input and cannot complete a goal.

The interactive host asks for scope approval before execution and completion
approval after verifier evidence covers all criteria. Decisions, local operator
identity, timestamps, contract and graph hashes, and source fingerprints are
persisted in the run record. Noninteractive runs stop with `needs_user`.
Declined completion can be revisited with `graph_resume({runId})` without
rerunning the verifier. `graph_status` exposes phase and approval history.
Only the tool's final `status=complete` authorizes goal completion.

Checkpoints fingerprint HEAD, index entries, tracked files, nonignored untracked
files, executable modes, and symlink targets. Evidence records receive the
source fingerprint and contract hash from the harness. Verifiers must leave
source unchanged. Governed runs serialize nodes and lock the checkout and run
to avoid overlapping executions. Resume refuses source/configuration/contract
drift; interrupted work additionally requires human approval before replay.
Legacy runs without contracts require a new run. After a crash, lock directories
must be removed manually only after confirming no runner is active.

These checkpoints identify source state; they do not store file contents or
restore a lost checkout. Ignored build artifacts and external dependencies are
outside the fingerprint, and submodule checkouts are currently rejected. Agent
evidence remains a claim bound to source, rather than an independently verified
test attestation. Approval records use local filesystem trust and the local
operator name, not an authenticated remote identity. Independent acceptance,
credential isolation, and trusted publication remain future unattended-run work.

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

Expect CLI version `1.5.2`, the configured model in the catalog, the exact
packages in `packages.lock.json`, and any machine-configured MCP servers (an
empty server list is valid). `check:setup` requires the configured packages to be installed at their
pinned versions. It fails on resource-loading errors, warnings, or built-in
command conflicts; it does not run session-start hooks or make a model request.
Start `pi` for interactive skill, delegation, graph, and permission smoke tests.
