
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

function Invoke-Symlink($shortcutTarget, $shortcutName) {
  New-Item -Type SymbolicLink -Path "$shortcutName" -Target "$shortcutTarget"
}

Write-Output "User home dir is = $env:USERPROFILE"
Write-Output "Installing dotfiles..."

# scripts
Set-Location $env:USERPROFILE
Backup-Item 'bin'
Invoke-Symlink "$dotfilesPath\Windows\bin" "bin"

# install powershell modules
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name ZLocation -Repository PSGallery

# powershell 5.x user profile
$powershell5home = "$env:USERPROFILE\Documents\WindowsPowerShell"
New-Folder-If-Not-Exist($powershell5home)
Set-Location $powershell5home
Backup-Item 'Microsoft.PowerShell_profile.ps1'
Invoke-Symlink "$dotfilesPath\Windows\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" "Microsoft.PowerShell_profile.ps1"

# powershell 7.x user profile
$powershell7home = "$env:USERPROFILE\Documents\PowerShell"
New-Folder-If-Not-Exist($powershell7home)
Set-Location $powershell7home
Backup-Item 'Profile.ps1'
Invoke-Symlink "$dotfilesPath\PowerShell\Microsoft.PowerShell_profile.ps1" "Profile.ps1"

# windows terminal
Set-Location $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
Backup-Item 'settings.json'
Invoke-Symlink "$dotfilesPath\Windows\gui_terminals\Windows_Terminal\settings.json" "settings.json"

# windows terminal preview
Set-Location $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState
Backup-Item 'settings.json'
Invoke-Symlink "$dotfilesPath\Windows\gui_terminals\Windows_Terminal_Preview\settings.json" "settings.json"

# VS Code settings
Set-Location $env:APPDATA\Code\User
Backup-Item 'settings.json'
Invoke-Symlink "$dotfilesPath\vs-code\settings_sb3.json" "settings.json"
Invoke-Symlink "$dotfilesPath\vs-code\keybindings.json" "keybindings.json"
# VS Code extensions
powershell "$dotfilesPath\vs-code\vs_code_restore_extensions_sb3.ps1"

# lazygit config
Set-Location $env:APPDATA\lazygit
Backup-Item 'config.yml'
Invoke-Symlink "$dotfilesPath\lazygit\config.yml" "config.yml"

# alacritty config
Set-Location $env:APPDATA\alacritty
Backup-Item 'alacritty.yml'
Invoke-Symlink "$dotfilesPath\gui_terminals\alacritty\alacritty_win.yml" "alacritty.yml"

# vim setup
# backup vim folders and files
Set-Location $env:USERPROFILE
Backup-Item 'vimfiles'
Backup-Item '.vim'
Backup-Item '.vimrc'
# creating vim folders
New-Item $HOME/vimfiles/swap -itemType Directory -Force
New-Item $HOME/vimfiles/backups -itemType Directory -Force
New-Item $HOME/vimfiles/undo -itemType Directory -Force
# symlinking colors dir
New-Item -itemtype symboliclink -path $HOME/vimfiles -name colors -value $HOME/dotfiles/vim/.vim/colors
# symlinking .vim to vimfiles (practical, to have it as *nix)
New-Item -itemtype symboliclink -path $HOME -name .vim -value $HOME/vimfiles
# symlinking .vimrc
New-Item -itemtype symboliclink -path $HOME -name .vimrc -value $HOME/dotfiles/vim/.vimrc
# install vim-plug
if (!(Test-Path $HOME/vimfiles/autoload/plug.vim)) {
  Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
      New-Item $HOME/vimfiles/autoload/plug.vim -Force
}

# return home
Set-Location $env:USERPROFILE

Write-Output "Done."
