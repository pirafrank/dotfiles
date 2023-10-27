# Alacritty

About Alacritty configuration.

**Configuration Paths**

| OS      | Configuration Path                                           |
| :------ | :----------------------------------------------------------- |
| BSD     | `$XDG_CONFIG_HOME/alacritty/alacritty.yml` or `$XDG_CONFIG_HOME/alacritty.yml` or `$HOME/.config/alacritty/alacritty.yml` or `$HOME/.alacritty.yml` |
| Linux   | `$XDG_CONFIG_HOME/alacritty/alacritty.yml` or `$XDG_CONFIG_HOME/alacritty.yml` or `$HOME/.config/alacritty/alacritty.yml` or `$HOME/.alacritty.yml` |
| macOS   | `$XDG_CONFIG_HOME/alacritty/alacritty.yml` or `$XDG_CONFIG_HOME/alacritty.yml` or `$HOME/.config/alacritty/alacritty.yml` or `$HOME/.alacritty.yml` |
| Windows | `%APPDATA%\\alacritty\\alacritty.yml` (backslash escape needed) |

**Online man pages**

https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.1.scd

https://www.mankier.com/1/alacritty

**Online man pages (configuration)**

Alacritty uses TOML config format, popular among Rust-developed apps.

https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd

**Themes**

- https://github.com/alacritty/alacritty-theme

- [themer.dev](https://themer.dev/)

- [terminal.sexy](https://terminal.sexy)

- [4bit. Terminal Color Scheme Designer](https://ciembor.github.io/4bit/)

### Install

Unix-like

```sh
mkdir -p "$HOME/.config/alacritty"
ln -sf "$HOME/dotfiles/terminals/alacritty/alacritty_$(uname -s).yml" "$HOME/.config/alacritty/alacritty.yml"
```

Windows

```pwsh
symlink  "$env:USERPROFILE\dotfiles\terminals\alacritty\alacritty_win.yml" "$env:APPDATA\alacritty\alacritty.yml"
```

### Alacritty x PowerShell (Windows shortcut)

Useful if you use Alacritty config to start a WSL shell and want another shortcut to start PowerShell in Alacritty.

1. Create a new Shortcut in `%APPDATA%\Microsoft\Windows\Start Menu\Programs`
2. Edit its Properties > Location with the following (note: adjust paths to match your Alacritty installation and User dirs).

```txt
C:\Users\francesco\scoop\apps\alacritty\current\alacritty.exe --config-file "C:\Users\francesco\dotfiles\terminals\alacritty\alacritty_pwsh.yml" --working-directory "%USERPROFILE%"
```
