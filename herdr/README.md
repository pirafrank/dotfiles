# Herdr configuration

This directory contains the Herdr configuration and installers that symlink it
into Herdr's per-user config directory.

## Config paths

- Windows: `%APPDATA%\herdr\config.toml` (typically
  `$env:USERPROFILE\AppData\Roaming\herdr\config.toml`)
- Linux and macOS: `~/.config/herdr/config.toml`

Both installers locate this repository from the script's own path, so the
repository can be checked out under any username or directory. The Windows
installer links `config_wsl.toml` to Herdr's `config.toml` path; Linux and macOS
link the Unix `config.toml` directly.

On Windows, new Herdr panes and tabs launch through `wsl.exe` and use WSL's
default distribution. New tabs follow the focused pane's working directory,
matching WezTerm's `CurrentPaneDomain` tab behavior. WezTerm explicitly targets
`Ubuntu-20.04`; Herdr's `terminal.default_shell` accepts only an executable, so
it uses the WSL default distribution. Since Ubuntu-20.04 is already your WSL
default, Herdr will use that distro too.

## Install

On Windows, run PowerShell from any directory:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\dotfiles\herdr\install.ps1"
```

On Linux or macOS, run:

```sh
sh ~/dotfiles/herdr/install.sh
```

If a different `config.toml` already exists at the destination, the installer
renames it to a timestamped `.bak` file before creating the symlink. Running an
installer again when the symlink already points to this repository is a no-op.

## Keybindings

| Action | Shortcut |
| --- | --- |
| Reload config | `Ctrl+Shift+R` |
| Previous tab in the current space | `Ctrl+Shift+Left` |
| Next tab in the current space | `Ctrl+Shift+Right` |
| Open a tab | `Ctrl+Shift+T` |
| Close a tab | `Ctrl+Shift+W` |
| Rename a tab | `Ctrl+Shift+I` |
| Previous agent | `Ctrl+Shift+H` |
| Next agent | `Ctrl+Shift+L` |
| Previous space | `Ctrl+Alt+Left` |
| Next space | `Ctrl+Alt+Right` |
| Create a space | `Ctrl+Shift+N` |
| Close a space | `Ctrl+Shift+D` |
| Rename a space | `Ctrl+Shift+E` |
