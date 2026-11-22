# Herdr TUI configuration

This configuration is for the Herdr TUI running on Linux. It supports Linux
desktop and headless sessions, and Linux shells inside WSL2. It does not
configure `hc` (Herdr Code).

The config is installed at `~/.config/herdr/config.toml` (or
`$XDG_CONFIG_HOME/herdr/config.toml` when `XDG_CONFIG_HOME` is set). From Linux,
including a WSL2 shell, install it with:

```sh
sh ~/dotfiles/herdr/tui/install.sh
```

The installer finds this repository from its own path. If another config
already exists at the destination, it renames it to a timestamped `.bak` file
before creating the symlink. Re-running it when the symlink already points to
this repository is a no-op.

## Keybindings

| Action | Shortcut |
| --- | --- |
| Prefix | `Ctrl+A` |
| Reload config | `Prefix`, then `Shift+R` |
| Detach | `Prefix`, then `D` |
| Open a tab | `Prefix`, then `T` |
| Previous / next tab | `Ctrl+Left` / `Ctrl+Right` |
| Close / rename tab | `Prefix`, then `Shift+K` / `,` |
| Open Go To picker | `Prefix`, then `A` |
| Previous / next agent | `Prefix`, then `[` / `]` |
| Focus agent 1–9 | `Prefix`, then `1`–`9` |
| Select tab 1–9 | `Prefix`, then `Shift+1`–`Shift+9` |
| Move between panes | `Prefix`, then `H` / `J` / `K` / `L`, or `Alt+Arrow` |
| Split right / down | `Prefix`, then `V` / `-` |
| Open workspace picker | `Prefix`, then `W` |
| Create / close / rename workspace | `Prefix`, then `N` / `Shift+D` / `E` |
