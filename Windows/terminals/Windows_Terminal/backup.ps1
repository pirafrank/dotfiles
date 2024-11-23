Write-Host "Backup of Windows Terminal (stable) settings.json"
Copy-Item "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Destination ".\settings.json"
Write-Host "Done"