
# vars

$dotfilesPath = "$env:USERPROFILE\dotfiles"

# functions

function Backup-Item($FileName) {
    if (Test-Path $FileName) {
      Rename-Item -Path $FileName -NewName "$FileName.bak" -Force
    }
}

function New-Folder-If-Not-Exist($path){
  If(!(test-path -PathType container $path))
  {
    New-Item -ItemType Directory -Path $path -Force
  }
}

# check dotfiles dir to exist
if (!(test-path $dotfilesPath)){
  Write-Host "$dotfilesPath dir not found. Quitting..."
  exit
}

function Invoke-Symlink($shortcutTarget, $shortcutName) {
  New-Item -Type SymbolicLink -Path "$shortcutName" -Target "$shortcutTarget"
}

Write-Output "User home dir is = $env:USERPROFILE"
Write-Output "Installing dotfiles..."

# scripts
Backup-Item "$env:USERPROFILE\bin"
Invoke-Symlink "$dotfilesPath\Windows\bin" "$env:USERPROFILE\bin"

# install powershell modules
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name ZLocation -Repository PSGallery

# powershell 5.x user profile
$powershell5home = "$env:USERPROFILE\Documents\WindowsPowerShell"
New-Folder-If-Not-Exist "$powershell5home"
Backup-Item "$powershell5home\Microsoft.PowerShell_profile.ps1"
Invoke-Symlink "$dotfilesPath\Windows\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" "$powershell5home\Microsoft.PowerShell_profile.ps1"

# powershell 7.x user profile
$powershell7home = "$env:USERPROFILE\Documents\PowerShell"
New-Folder-If-Not-Exist "$powershell7home"
Backup-Item "$powershell7home\Profile.ps1"
Invoke-Symlink "$dotfilesPath\PowerShell\Profile.ps1" "$powershell7home\Profile.ps1"

# windows terminal
$win_term_home = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
New-Folder-If-Not-Exist "$win_term_home"
Backup-Item "$win_term_home\settings.json"
Invoke-Symlink "$dotfilesPath\Windows\terminals\Windows_Terminal\settings.json" "$win_term_home\settings.json"

# windows terminal preview
$win_term_pre_home = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState"
New-Folder-If-Not-Exist "$win_term_pre_home"
Backup-Item "$win_term_pre_home\settings.json"
Invoke-Symlink "$dotfilesPath\Windows\terminals\Windows_Terminal_Preview\settings.json" "$win_term_pre_home\settings.json"

# VS Code settings
$vs_code_home = "$env:APPDATA\Code\User"
New-Folder-If-Not-Exist "$vs_code_home"
Backup-Item "$vs_code_home\settings.json"
Backup-Item "$vs_code_home\keybindings.json"
Invoke-Symlink "$dotfilesPath\vs-code\settings_sb3.json" "$vs_code_home\settings.json"
Invoke-Symlink "$dotfilesPath\vs-code\keybindings.json" "$vs_code_home\keybindings.json"
# VS Code extensions
powershell "$dotfilesPath\vs-code\vs_code_restore_extensions_sb3.ps1"

# lazygit config
$lazygit_home = "$env:APPDATA\lazygit"
New-Folder-If-Not-Exist "$lazygit_home"
Backup-Item "$lazygit_home\config.yml"
Invoke-Symlink "$dotfilesPath\lazygit\config.yml" "$lazygit_home\config.yml"

# alacritty config
$alacritty_home = "$env:APPDATA\alacritty"
New-Folder-If-Not-Exist "$alacritty_home"
Backup-Item "$alacritty_home\alacritty.toml"
Invoke-Symlink "$dotfilesPath\terminals\alacritty\alacritty_wsl.toml" "$alacritty_home\alacritty.toml"

# wezterm config
$wezterm_home = "$env:USERPROFILE"
#New-Folder-If-Not-Exist "$wezterm_home"
Backup-Item "$wezterm_home\.wezterm.lua"
Invoke-Symlink "$dotfilesPath\terminals\wezterm\.wezterm.lua" "$wezterm_home\.wezterm.lua"

# vim setup
# backup vim folders and files
Backup-Item "$env:USERPROFILE\vimfiles"
Backup-Item "$env:USERPROFILE\.vim"
Backup-Item "$env:USERPROFILE\.vimrc"
# creating vim folders
New-Item "$env:USERPROFILE\vimfiles\swap" -itemType Directory -Force
New-Item "$env:USERPROFILE\vimfiles\backups" -itemType Directory -Force
New-Item "$env:USERPROFILE\vimfiles\undo" -itemType Directory -Force
# symlinking colors dir
New-Item -itemtype symboliclink -path "$env:USERPROFILE\vimfiles" -name colors -value "$env:USERPROFILE\dotfiles\vim\.vim\colors"
# symlinking .vim to vimfiles (practical, to have it as *nix)
New-Item -itemtype symboliclink -path "$env:USERPROFILE" -name .vim -value "$env:USERPROFILE\vimfiles"
# symlinking .vimrc
New-Item -itemtype symboliclink -path "$env:USERPROFILE" -name .vimrc -value "$env:USERPROFILE\dotfiles\vim\.vimrc"
# install vim-plug
if (!(Test-Path "$env:USERPROFILE\vimfiles\autoload\plug.vim")) {
  Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
      New-Item "$env:USERPROFILE\vimfiles\autoload\plug.vim" -Force
}

Write-Output "Done."
