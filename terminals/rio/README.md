# Rio

- Docs: https://raphamorim.io/rio/

- Code: [raphamorim/rio](https://github.com/raphamorim/rio)

### Config

Configuration lives here:

| OS      | Configuration Path                                           |
|:------- |:------------------------------------------------------------ |
| Linux   | `$HOME/.config/rio/config.toml`                              |
| macOS   | `$HOME/.config/rio/config.toml`                              |
| Windows | `%LOCALAPPDATA%\\rio\\config.toml` (backslash escape needed) |

Config options:

- https://raphamorim.io/rio/docs/config

### Install

Unix-like

```sh
mkdir -p "$HOME/.config/rio"
ln -sf "$HOME/dotfiles/terminals/rio/config_$(uname -s).toml" "$HOME/.config/rio/config.toml"
```

Windows

```pwsh
symlink  "$env:USERPROFILE\dotfiles\terminals\rio\config_wsl.toml" "$env:LOCALAPPDATA\rio\config.toml"
```

### Themes

Themes are installed in `themes` subdir inside the config dir.


