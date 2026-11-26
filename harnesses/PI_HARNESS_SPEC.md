# Pi Harness Spec: Data-Driven `bots/` Wiring & `pi-bot`

Status: Draft specification for future implementation in `~/dotfiles/harnesses/pi/`.

## 1. Goals & Constraints

- **Keep `pirafrank/dotfiles` public and data-driven:** No private bot names, prompts, or memory content may be hardcoded in `dotfiles/harnesses/pi/`. All discovery MUST be dynamic from `$SKILLS_SRC/bots/*`.
- **Preserve existing roles wiring:** `~/.pi/agent/agents -> $SKILLS_SRC/roles` MUST remain untouched for stateless subagents.
- **Separate definitions from live state:**
  - Bot definitions live in `pirafrank/skills/bots/<name>/` (`SOUL.md`, `MEMORY.example.md`, `bot.json`), symlinked into `~/.pi/agent/bots` (or `$PI_CODING_AGENT_DIR/bots`).
  - Live bot state (`MEMORY.md` and `diary/YYYY-MM-DD.md`) lives in the private `pirafrank/bot-state` repo (`~/code/projects/bot-state`), symlinked by its own install script to:
    - **Linux:** `${XDG_STATE_HOME:-$HOME/.local/state}/bots-state`
    - **Windows 11 (pwsh):** `$env:LOCALAPPDATA\bots-state`

---

## 2. Changes to `dotfiles/harnesses/pi/install.sh`

### 2.1 Sync Mode (`MODE=sync`)

After linking `roles` and `prompts`, link `bots/` only when `$SKILLS_SRC/bots` exists (graceful no-op if a consumer does not have `bots/`):

```bash
if [[ -d "$SKILLS_SRC/bots" ]]; then
  link_owned "$SKILLS_SRC/bots" "$pi_root/bots"
fi
```

*(Alternative: if third-party bots will ever coexist in `$pi_root/bots`, mirror the `$pi_root/skills` hub pattern with `mkdir -p "$pi_root/bots"` and per-bot `link_owned` + `remove_owned_children`. Starting with a single directory symlink matches `roles` and `prompts`.)*

### 2.2 Uninstall Mode (`UNINSTALL=1`)

Add `bots` to the `for resource in ...` cleanup loop in `install.sh`:

```bash
for resource in AGENTS.md roles agents bots prompts settings.json harness.json model-router.json extensions; do
  remove_owned "$uninstall_root/$resource"
done
```

### 2.3 Launcher Installation

Install or symlink `pi-bot` onto `PATH` (e.g., `~/.local/bin/pi-bot` on Linux; a matching `pi-bot.ps1` wrapper or shim on Windows 11) from `dotfiles/harnesses/pi/bin/pi-bot`.

---

## 3. `pi-bot <name>` Launcher Contract

### 3.1 CLI Interface

```text
pi-bot --list
pi-bot <name> [pi-args...]
```

- `--list`: Enumerate every valid bot directory under `$BOTS_DIR` (contains `SOUL.md` and `bot.json`), printing `<name>\t<description>`.
- `<name>`: Resolve bot directory `$BOTS_DIR/<name>`. Exit non-zero with a clear message if missing or if `SOUL.md` / `bot.json` is absent.
- Remaining `[pi-args...]` MUST be forwarded verbatim to `pi`.

### 3.2 Path Resolution

| Variable | Linux default | Windows 11 (pwsh) default |
| --- | --- | --- |
| `PI_CODING_AGENT_DIR` | `$HOME/.pi/agent` | `$env:USERPROFILE\.pi\agent` |
| `BOTS_DIR` | `$PI_CODING_AGENT_DIR/bots` | `$PI_CODING_AGENT_DIR\bots` |
| `BOTS_STATE_DIR` | `${XDG_STATE_HOME:-$HOME/.local/state}/bots-state` | `$env:LOCALAPPDATA\bots-state` |

### 3.3 Session Startup Sequence

1. **Validate bot definition:** Read `$BOTS_DIR/<name>/bot.json` and confirm `$BOTS_DIR/<name>/SOUL.md` exists.
2. **Ensure state directory exists:** Create `$BOTS_STATE_DIR/<name>/diary` if missing.
3. **Seed `MEMORY.md` on first run:**
   - Target path: `$BOTS_STATE_DIR/<name>/MEMORY.md`.
   - If missing and `bot.json` specifies `memoryTemplate` (e.g., `MEMORY.example.md`) and that file exists in `$BOTS_DIR/<name>/`, copy it to `$BOTS_STATE_DIR/<name>/MEMORY.md`.
   - Otherwise create an empty `MEMORY.md` with `# <name> Memory`.
4. **Optional state repo freshness check (non-blocking):**
   - If `$BOTS_STATE_DIR` is a Git repository, optionally warn (do not abort) when the branch is behind upstream or has uncommitted changes from another session.
5. **Compose runtime prompt context & launch Pi:**
   Pass the bot identity and live state into Pi using **one** of the two mechanisms in Section 4.

---

## 4. Loading `SOUL.md` + `MEMORY.md` in Pi

### Option 1 — Thin Wrapper Launcher (Recommended first step)

Generate a temporary or per-session system prompt file (or pass `--append-system-prompt` / `--system-prompt`, depending on the installed `pi` CLI flags) containing:

1. Full contents of `$BOTS_DIR/<name>/SOUL.md`.
2. A runtime state binding block:
   ```markdown
   ## Runtime State Paths (Pi)
   - Your live `MEMORY.md` file is at: `<resolved-path>/MEMORY.md`
   - Your daily diary folder is at: `<resolved-path>/diary/` (today: `YYYY-MM-DD.md`)
   - Follow the Self-Modification & Memory Policy in your SOUL when updating `MEMORY.md`.
   ```
3. Current contents of `<resolved-path>/MEMORY.md`.
4. Optional hint listing declared `skills` and `roles` from `bot.json` so Pi knows which installed skills/subagents are preferred for this bot.

Then `exec pi ... [pi-args...]`.

### Option 2 — Native Pi Extension (`extensions/bot-session.ts`)

When deeper Pi integration is desired (e.g., `/bot <name>` switching inside an active session or automatic post-session diary summaries):

- Read `PI_BOT_NAME` (set by `pi-bot <name>`) or handle a `/bot <name>` command.
- On session start (`before_agent_start` / system prompt hook):
  - Resolve `$BOTS_DIR/<name>/SOUL.md` and `$BOTS_STATE_DIR/<name>/MEMORY.md` (seeding from `memoryTemplate` if missing).
  - Inject `SOUL.md`, resolved state paths, and `MEMORY.md` into the system prompt.
  - Guard against edits to `SOUL.md` (optional tool-call guard enforcing the read-only soul policy).
- On session end (optional): prompt or append a short dated summary to `$BOTS_STATE_DIR/<name>/diary/YYYY-MM-DD.md`.

**Recommended rollout:** Start with **Option 1** (zero Pi extension API surface to maintain, works identically from Bash and PowerShell), and graduate to **Option 2** only if you want in-session `/bot` switching or automated diary hooks.

---

## 5. Acceptance Criteria

- [ ] Running `install.sh` on a machine *without* `$SKILLS_SRC/bots` succeeds cleanly.
- [ ] Running `install.sh` on a machine *with* `$SKILLS_SRC/bots` creates `~/.pi/agent/bots -> $SKILLS_SRC/bots` without modifying `~/.pi/agent/agents`.
- [ ] Running `install.sh --uninstall` removes `~/.pi/agent/bots` cleanly.
- [ ] `pi-bot --list` discovers all bots dynamically with zero bot names hardcoded in `dotfiles`.
- [ ] `pi-bot architect` seeds `$BOTS_STATE_DIR/architect/MEMORY.md` on first run, loads `SOUL.md` + `MEMORY.md`, and exposes the resolved `MEMORY.md` path to the session.
- [ ] `grep -rn "spec-writer\|architect" ~/dotfiles/harnesses/pi/` returns zero matches.
