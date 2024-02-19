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

## Install

```bash
ln -s ${HOME}/dotfiles/mc/config ${HOME}/.config/mc
ln -s ${HOME}/dotfiles/mc/skins ${HOME}/.local/share/mc/skins
```

## Set a theme in config

Set `skin` value to the filename without the `.ini` extension.

```
sed -i 's|\(^skin=\).*$|\1onedark|' ${HOME}/.config/mc/ini
```

### Themes credits

- https://draculatheme.com/midnight-commander
- https://github.com/DeadNews/mc-onedark
- https://github.com/mstilkerich/mc-solarized-truecolor
