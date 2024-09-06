param (
  # first argument given is the Windows path to open in WSL
  [string]$windowsPath
)

$escapedPath = $windowsPath -replace '\\', '\\\\'
$linuxPath = wsl wslpath "$escapedPath"
wsl -e bash -c "cd '$linuxPath'; exec zsh"
