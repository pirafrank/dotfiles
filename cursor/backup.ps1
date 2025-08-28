Write-Host "Backup of Cursor MCP configuration"
Copy-Item "$env:USERPROFILE\.cursor\mcp.json" -Destination ".\mcp.json"
Write-Host "Done"