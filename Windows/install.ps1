function bkpitem($FileName) {
    if (Test-Path $FileName) { 
      Rename-Item -Path $FileName -NewName "$FileName.bak"
    }
}

Write-Output $env:USERPROFILE
Write-Output "Installing..."

# scripts
Set-Location $env:USERPROFILE
bkpitem('bin')
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\Windows\bin bin

# powershell user profile
Set-Location $env:USERPROFILE\Documents\WindowsPowerShell
bkpitem('Microsoft.PowerShell_profile.ps1')
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\Windows\PowerShell\Microsoft.PowerShell_profile.ps1 Microsoft.PowerShell_profile.ps1

# windows terminal
Set-Location $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
bkpitem('settings.json')
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\Windows\gui_terminals\Windows_Terminal\settings.json settings.json

# windows terminal preview
Set-Location $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState
bkpitem('settings.json')
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\Windows\gui_terminals\Windows_Terminal_Preview\settings.json settings.json

# VS Code settings
Set-Location $env:APPDATA\Code\User
bkpitem('settings.json')
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\vs-code\settings_sb3.json settings.json
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\vs-code\keybindings.json keybindings.json
# VS Code extensions
powershell "$env:USERPROFILE\dotfiles\vs-code\vs_code_restore_extensions_sb3.ps1"

# alacritty config
Set-Location $env:APPDATA\alacritty
bkpitem('alacritty.yml')
powershell "$env:USERPROFILE\dotfiles\Windows\bin\symlink.ps1" $env:USERPROFILE\dotfiles\gui_terminals\alacritty\alacritty_win.yml alacritty.yml

# return home
Set-Location $env:USERPROFILE

Write-Output "Done."
