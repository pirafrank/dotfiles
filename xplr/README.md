# xplr

TUI file explorer

## Docs

- https://xplr.dev/en/configuration
- https://xplr.dev/en/general-config

## Config

Config lives in `~/.config/xplr/`. By default xplr loads a `init.lua` script in there.

Config files in there are symlinked to files in this dotfiles dir.

There are two alternative versions of the `init.lua` script:

- `init_no_plugins.lua`, to run custom configuration without plugins.
- `init_empty.lua`, to run stock configuration without plugins.

Use `--config /path/to/init.lua` to explicitly use one of those.

## Plugins

Plugins must be cloned into `$HOME/.config/xplr/plugins`. There's a lua script for that, just run the command below in a shell. Lua is required.

```sh
lua clone_plugins.lua
```

