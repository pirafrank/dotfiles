# Separate Codex CLI workspaces

Use `codex` for ChatGPT Business and `codex-enterprise` for ChatGPT Enterprise
to keep their sessions, settings, history, and credentials separate:

| Command | Workspace | State directory |
| --- | --- | --- |
| `codex` | Business | `~/.codex` by default |
| `codex-enterprise` | Enterprise | `~/.codex-enterprise` |

Plain `codex` uses `CODEX_HOME` if it is already set in your environment;
leave it unset to use `~/.codex`. The `codex-enterprise` wrapper sets
`CODEX_HOME` only for the launched command. The commands do not select an
organization automatically; choose the matching workspace when signing in.

This isolates **local Codex state**, not filesystem access or organization
permissions. Always confirm which workspace is selected during browser sign-in;
`codex login status` may only report `Logged in using ChatGPT`.

## Shell setup

- **PowerShell 7:** `PowerShell/Profile.ps1` lazy-registers `codex-enterprise`
  from `PowerShell/Functions/`. Restart `pwsh` (or reload its profile).
- **Zsh:** `zsh/zprezto/runcoms/zshrc` already automatically autoloads functions
  from `zsh/autoloaded/`. Start a new interactive Zsh shell.

## Initial login

From the corresponding shell, run:

```sh
codex login
codex-enterprise login
```

Choose the **Business** workspace during the first browser authentication and
**Enterprise** during the second. Afterward:

```sh
codex login status
codex-enterprise login status
codex
codex-enterprise
```

The wrapper forwards arguments unchanged (for example, `codex-enterprise exec ...`).

## Migrate an existing `~/.codex` safely

**Close all Codex processes first**, including Codex sessions in editor
integrations using the same directory. Decide which organization owns your
current `~/.codex` session. **Do not guess.** Check existing session context
and, if uncertain, keep it as `~/.codex` and authenticate the Enterprise home
separately instead of moving credentials into the wrong workspace.

If your existing session belongs to **Business**, keep it in `~/.codex` and
continue using `codex`. No migration is needed. The migration below is only
for an existing **Enterprise** session that should use `codex-enterprise`.

Do not copy a single `auth.json` into both organizations: this would duplicate
credentials, not give you separate logins.

### Zsh (Linux, macOS, WSL)

For an existing **Enterprise** session:

```zsh
# Stop if the destination exists: never overwrite its config or login.
[[ -d "$HOME/.codex" && ! -e "$HOME/.codex-enterprise" ]] && \
  mv -- "$HOME/.codex" "$HOME/.codex-enterprise"
```

If the condition is false, **inspect the directories instead of forcing** the
move. The command renames the whole Codex home, preserving its config, auth,
logs and history. `mv` is appropriate here because all paths share the home
filesystem. Start the matching command and sign in again if needed.

### PowerShell 7 (Windows)

For an existing **Enterprise** session:

```powershell
$source = Join-Path $HOME '.codex'
$destination = Join-Path $HOME '.codex-enterprise'
if ((Test-Path -LiteralPath $source -PathType Container) -and
    -not (Test-Path -LiteralPath $destination)) {
    Move-Item -LiteralPath $source -Destination $destination
} else {
    Write-Warning 'Migration skipped: source missing or destination exists.'
}
```

If Windows reports a locked directory or file, close programs using Codex and retry.
Do not merge/overwrite an existing destination; back up and reconcile it
manually. After migration, `codex-enterprise` will use the moved state.
Run `codex login` and select **Business** to authenticate a fresh `~/.codex`.

> PowerShell and WSL generally have **different home directories**. Migrate
> the Codex home in each environment separately when needed.

## Notes

- The Enterprise wrapper's `CODEX_HOME` is scoped to the launched command. Other commands in the same
  shell and already-running Codex sessions are unaffected.
- Individual sessions do not dynamically change organizations. Stop a session
  and launch the other command to switch.
- Each home can have independent `config.toml`, skills, authentication and
  session history; synchronize only non-secret settings intentionally.
- Use `codex logout` / `codex-enterprise logout` to sign out of just
  that home.
