# Zellij keybindings

Zellij is a terminal multiplexer with modal keybindings. The config clears default keybindings and uses custom ones.

**Note**: Press `Alt+?` from any mode to show the keybindings help plugin.

Full configuration in [./config.kdl](./config.kdl).

## Mode Switching

|Keybinding|Action|
|---|---|
|`Alt+p`|Switch to Pane mode|
|`Alt+y`|Switch to Tab mode|
|`Alt+r`|Switch to Resize mode|
|`Alt+s`|Switch to Scroll mode|
|`Alt+m`|Switch to Move mode|
|`Alt+o`|Switch to Session mode|
|`Alt+b`|Switch to Tmux mode|
|`Ctrl+g`|Toggle Locked mode (disable keybindings)|
|`Enter` or `Esc`|Return to Normal mode (from most modes)|

## Global Keybindings (available in most modes)

|Keybinding|Action|
|---|---|
|`Ctrl+q`|Quit zellij|
|`Alt+n`|New pane|
|`Alt+t`|New tab|
|`Alt+e`|Rename current tab|
|`Alt+w`|Switch focus between panes|
|`Alt+h/j/k/l`|Move focus left/down/up/right|
|`Alt+Left/Right`|Go to previous/next tab|
|`Alt+</>`|Move tab left/right|
|`Alt+=` or `Alt++`|Increase pane/tab size|
|`Alt+-`|Decrease pane/tab size|
|`Alt+[/]`|Previous/Next swap layout|
|`Alt+/`|Open room plugin (floating)|
|`Alt+.`|Open jump list plugin (floating)|

## Pane Mode (`Alt+p`)

|Keybinding|Action|
|---|---|
|`h/j/k/l` or arrows|Move focus between panes|
|`p`|Switch focus to next pane|
|`n`|New pane (default direction)|
|`d`|New pane down|
|`r`|New pane right|
|`x`|Close focused pane|
|`f`|Toggle fullscreen for focused pane|
|`z`|Toggle pane frames|
|`w`|Toggle floating panes|
|`e`|Toggle embed or floating for pane|
|`c`|Rename pane|

## Tab Mode (`Alt+y`)

|Keybinding|Action|
|---|---|
|`h/k/Left/Up`|Go to previous tab|
|`l/j/Right/Down`|Go to next tab|
|`t`|New tab|
|`x`|Close tab|
|`e`|Rename tab|
|`s`|Toggle sync input to all panes in tab|
|`b`|Break pane to new tab|
|`[/]`|Break pane left/right|
|`1-9`|Go to tab number 1-9|
|`Tab`|Toggle to last active tab|

## Resize Mode (`Alt+r`)

|Keybinding|Action|
|---|---|
|`h/j/k/l` or arrows|Increase pane size left/down/up/right|
|`H/J/K/L`|Decrease pane size left/down/up/right|
|`=` or `+`|Increase size|
|`-`|Decrease size|

## Move Mode (`Alt+m`)

|Keybinding|Action|
|---|---|
|`n` or `Tab`|Move pane to next position|
|`p`|Move pane backwards|
|`h/j/k/l` or arrows|Move pane left/down/up/right|

## Scroll Mode (`Alt+s`)

|Keybinding|Action|
|---|---|
|`e`|Edit scrollback in `$EDITOR`|
|`s`|Enter search mode|
|`j/k` or `Down/Up`|Scroll down/up|
|`h/l` or `Left/Right`|Page scroll up/down|
|`Alt+f` or `PageDown`|Page scroll down|
|`Alt+b` or `PageUp`|Page scroll up|
|`d`|Half page scroll down|
|`u`|Half page scroll up|
|`Alt+c`|Scroll to bottom|

## Search Mode (from Scroll mode, press `s`)

|Keybinding|Action|
|---|---|
|`n`|Search down|
|`p`|Search up|
|`c`|Toggle case sensitivity|
|`w`|Toggle wrap search|
|`o`|Toggle whole word search|
|`Alt+c`|Scroll to bottom and exit|

## Session Mode (`Alt+o`)

|Keybinding|Action|
|---|---|
|`d`|Detach from session|
|`w`|Open session manager plugin|
|`Alt+s`|Switch to Scroll mode|

## Tmux Compatibility Mode (`Alt+b`)

For tmux users, this mode provides familiar keybindings with `Alt+b` as the prefix.

|Keybinding|Action|
|---|---|
|`[`|Enter scroll mode|
|`"`|New pane down|
|`%`|New pane right|
|`z`|Toggle fullscreen|
|`c`|New tab|
|`,`|Rename tab|
|`p/n`|Previous/Next tab|
|`h/j/k/l` or arrows|Move focus between panes|
|`o`|Focus next pane|
|`d`|Detach|
|`Space`|Next swap layout|
|`x`|Close focused pane|
