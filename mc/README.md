# Midnight Commander

dual-pane file manager.

## Links

- https://midnight-commander.org/
- https://midnight-commander.org/wiki/doc/common/skins

## Config path

```
~/.config/mc/ini
~/.config/mc/panels.ini
```

## Themes path

```
~/.local/share/mc/skins/
```

## Set theme in config

Set the filename without the `.ini` extension.

```
sed -i 's|\(^skin=\).*$|\1onedark|' ${HOME}/.config/mc/ini
```

### Themes credits

- https://draculatheme.com/midnight-commander
- https://github.com/DeadNews/mc-onedark
- https://github.com/mstilkerich/mc-solarized-truecolor

