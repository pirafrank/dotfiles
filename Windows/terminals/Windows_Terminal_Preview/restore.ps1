Write-Host "Backup of Windows Terminal Preview settings.json"
Copy-Item ".\settings.json" -Destination "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
Write-Host "Done"
