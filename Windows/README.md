# Windows dotfiles

This folder contais Windows-only files and config.

Anything else (e.g. cross-platform stuff) lives outside this folder.

Designed to work with PowerShell 7.x, but profile in `WindowsPowerShell` works with Windows PowerShell 5.1.

## Locations

Powershell user profile

```txt
%USERPROFILE%\Documents\WindowsPowerShell
```

Windows Terminal

```txt
%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
```

Windows Terminal Preview

```txt
%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState
```

VS Code settings

```txt
%APPDATA%\Code\User\settings.json
%APPDATA%\Code\User\keybindings.json
```

Alacritty config

```txt
%APPDATA%\alacritty\alacritty.yml
```
