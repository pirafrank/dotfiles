# PowerShell

- <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4>

## Install (PowerShell 7)

Symlink the profile to the PowerShell 7 profile location.

```powershell
function Invoke-Symlink($shortcutTarget, $shortcutName) {
    New-Item -Type SymbolicLink -Path "$shortcutName" -Target "$shortcutTarget"
}
Invoke-Symlink "$env:USERPROFILE\dotfiles\PowerShell\Profile.ps1" "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
```

## Layout

```text
PowerShell/
  Profile.ps1              # wiring only: aliases, env vars, lazy-loader stubs
  Functions/               # real command implementations (first-use loaded)
    gg.ps1
    cd2.ps1
    java.ps1
    ...
  Modules/
    pirafrank/             # prompt + git branch display
      pirafrank.psm1
      pirafrank.psd1
```

**Profile = wiring. Functions = commands. Modules = grouped features with shared helpers.**

## Performance

The profile avoids work at startup:

- No `Get-ChildItem` loops or dot-sourcing of script directories
- No `Import-Module` for heavy modules (PSFzf, Terminal-Icons, ZLocation)
- No `fnm env` during profile load; fnm initializes on first prompt render
- No PATH replacement (see below)

Commands are registered as tiny stubs via `Register-LazyCommand`. The real
implementation in `Functions/*.ps1` is dot-sourced on first invocation, then
the stub removes itself and redispatches.

### Adding a new lazy-loaded command

1. Create `PowerShell/Functions/my-cmd.ps1` with the real function body.
2. In `Profile.ps1`, add:

```powershell
Register-LazyCommand -Name my-cmd -SourceFile 'my-cmd.ps1'
```

For commands that share a file (e.g. `java8`/`java17` all in `java.ps1`),
register a stub per entry point. The shared file should remove all related
stubs when loaded.

### Already lazy at startup

| Feature | Trigger |
|---|---|
| PSFzf | First Ctrl+T, Ctrl+R, or Tab |
| Terminal-Icons | First prompt render |
| ZLocation | First `z` call |
| Chocolatey tab completion | First `choco` call |
| fnm / Node | First prompt render (with command-triggered lazy fallback) |
| All custom functions | First invocation of each command |

## PATH on Windows

`install_dotfiles.ps1` symlinks `%USERPROFILE%\bin` to `dotfiles\Windows\bin`.
The profile does **not** replace `$env:Path`. It only prepends `~\bin` if the
symlink exists and is missing from PATH.

## Measuring startup

```powershell
# pwsh baseline (no profile)
Measure-Command { pwsh -NoProfile -Command 'exit' } | Select-Object TotalMilliseconds

# pwsh with profile
Measure-Command { pwsh -Command 'exit' } | Select-Object TotalMilliseconds
```

The delta is profile overhead. The target is near-zero profile cost on top of
pwsh's own startup time, not literal 0 ms total.

The first prompt render includes the one-time fnm initialization cost. Measure that separately from process startup when evaluating interactive responsiveness.

## What to avoid in the profile

- `Get-ChildItem` loops
- `Import-Module` for large modules at startup
- Network paths, OneDrive-synced paths, and repeated disk I/O
- Replacing `$env:Path` with a single directory
