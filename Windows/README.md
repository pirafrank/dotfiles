# Windows dotfiles

This folder contais Windows-only files and config.

Anything else (e.g. cross-platform stuff) lives outside this folder.

Designed to work with PowerShell 7.x, but profile in `WindowsPowerShell` works with Windows PowerShell 5.1.

## Run it

1. First check your execution policy and change it to allow execution unsigned local scripts.

```pwsh
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

2. Download and run install script as admin:

```pwsh
# Open Admin PowerShell
irm https://github.com/pirafrank/dotfiles/raw/main/Windows/install_software.ps1 -outfile 'install_software.ps1'
.\install_software.ps1
```

3. Download and install user-space software:

```pwsh
# Open user PowerShell
irm https://github.com/pirafrank/dotfiles/raw/main/Windows/install_user_software.ps1 -outfile 'install_user_software.ps1'
.\install_user_software.ps1
```

## Install dotfiles

```pwsh
# Open Admin PowerShell
Set-Location "$env:USERPROFILE\dotfiles\Windows"
.\install_dotfiles.ps1
```

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
