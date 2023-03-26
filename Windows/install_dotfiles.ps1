
# vars

$dotfilesPath = "$env:USERPROFILE\dotfiles"

# functions

function Backup-Item($FileName) {
    if (Test-Path $FileName) { 
      Rename-Item -Path $FileName -NewName "$FileName.bak"
    }
}

function New-Folder-If-Not-Exist($path){
  If(!(test-path -PathType container $path))
  {
    New-Item -ItemType Directory -Path $path
  }
}

# check dotfiles dir to exist
if (!(test-path $dotfilesPath)){
  Write-Host "$dotfilesPath dir not found. Quitting..."
  exit
}

Write-Output "User home dir is = $env:USERPROFILE"
Write-Output "Installing dotfiles..."

# scripts
Set-Location $env:USERPROFILE
Backup-Item('bin')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\Windows\bin bin

# powershell 5.x user profile
$powershell5home = "$env:USERPROFILE\Documents\WindowsPowerShell"
New-Folder-If-Not-Exist($powershell5home)
Set-Location $powershell5home
Backup-Item('Microsoft.PowerShell_profile.ps1')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\Windows\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 Microsoft.PowerShell_profile.ps1

# powershell 7.x user profile
$powershell7home = "$env:USERPROFILE\Documents\PowerShell"
New-Folder-If-Not-Exist($powershell7home)
Set-Location $powershell7home
Backup-Item('Profile.ps1')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\Windows\PowerShell\Microsoft.PowerShell_profile.ps1 Profile.ps1

# windows terminal
Set-Location $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
Backup-Item('settings.json')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\Windows\gui_terminals\Windows_Terminal\settings.json settings.json

# windows terminal preview
Set-Location $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState
Backup-Item('settings.json')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\Windows\gui_terminals\Windows_Terminal_Preview\settings.json settings.json

# VS Code settings
Set-Location $env:APPDATA\Code\User
Backup-Item('settings.json')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\vs-code\settings_sb3.json settings.json
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\vs-code\keybindings.json keybindings.json
# VS Code extensions
powershell "$dotfilesPath\vs-code\vs_code_restore_extensions_sb3.ps1"

# alacritty config
Set-Location $env:APPDATA\alacritty
Backup-Item('alacritty.yml')
powershell "$dotfilesPath\Windows\bin\symlink.ps1" $dotfilesPath\gui_terminals\alacritty\alacritty_win.yml alacritty.yml

# return home
Set-Location $env:USERPROFILE

Write-Output "Done."
