Write-Host "Backup of VS Code settings.json"
Copy-Item "$env:USERPROFILE\AppData\Roaming\Code\User\settings.json" -Destination ".\settings.json"
Write-Host "Done"