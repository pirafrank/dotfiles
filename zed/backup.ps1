$sourceFile = "$env:USERPROFILE\AppData\Roaming\Zed\settings.json"
$destinationFile = ".\settings.json"

# Check if the destination exists and delete it if it does
if (Test-Path $destinationFile) {
  Remove-Item -Path $destinationFile -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFile -Destination $destinationFile

$sourceFile = "$env:USERPROFILE\AppData\Roaming\Zed\keymap.json"
$destinationFile = ".\keymap.json"

# Check if the destination exists and delete it if it does
if (Test-Path $destinationFile) {
  Remove-Item -Path $destinationFile -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFile -Destination $destinationFile
