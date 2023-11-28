# WezTerm

WezTerm info and configuration.

### Links

- [Home](https://wezfurlong.org/wezterm/)
- [Configuration files](https://wezfurlong.org/wezterm/config/files.html)
- [Configuration options](https://wezfurlong.org/wezterm/config/lua/config/index.html)
- [CLI usage and scripting](https://wezfurlong.org/wezterm/cli/general.html)
- [Color schemas](https://wezfurlong.org/wezterm/colorschemes/index.html)

### Configuration

| OS        | Configuration Path              |
| --------- | ------------------------------- |
| Unix-like | `~/.config/wezterm/wezterm.lua` |
| Windows   | `%USERPROFILE%\.wezterm.lua`    |

Show configuration keys:

```sh
wezterm show-keys
```

### Install

Unix-like

```sh
ln -s ~/dotfiles/terminals/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

Windows

```powershell
symlink  "C:\Users\francesco\dotfiles\terminals\wezterm\wezterm.lua" "C:\Users\francesco\.wezterm.lua"
```
