# Windows dotfiles

This folder contais Windows-only files and config.

Anything else (e.g. cross-platform stuff) lives outside this folder.

Designed to work with PowerShell 7.x, but profile in `WindowsPowerShell` may work with Windows PowerShell 5.1 as well.

## Full install

Run the following in an Administrator PowerShell:

```pwsh
# Check current execution policy
Get-ExecutionPolicy

# Change execution policy to allow execution unsigned local scripts.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Run the setup script
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pirafrank/dotfiles/main/Windows/setup/setup.ps1'))
```

## dotfiles-only

Run the following in an Administrator PowerShell:

```pwsh
Set-Location "$env:USERPROFILE\dotfiles\Windows"
.\install_dotfiles.ps1
```

## Locations

Powershell 5.x

```txt
%USERPROFILE%\Documents\WindowsPowerShell
```

Powershell 7.x

```txt
%USERPROFILE%\Documents\PowerShell"
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
%APPDATA%\alacritty\alacritty.toml
```

Wezterm config

```txt
%USERPROFILE%\.wezterm.lua
```
