Write-Host "Backup of Windows Terminal Canary settings.json"
Copy-Item "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalCanary_8wekyb3d8bbwe\LocalState\settings.json" -Destination ".\settings.json"
Write-Host "Done"
