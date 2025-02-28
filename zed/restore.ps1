$sourceFile = ".\settings.json"
$destinationFile = "$env:USERPROFILE\AppData\Roaming\Zed\settings.json"

# Check if the destination exists and delete it if it does
if (Test-Path $destinationFile) {
  Remove-Item -Path $destinationFile -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFile -Destination $destinationFile

$sourceFile = ".\keymap.json"
$destinationFile = "$env:USERPROFILE\AppData\Roaming\Zed\keymap.json"

# Check if the destination exists and delete it if it does
if (Test-Path $destinationFile) {
  Remove-Item -Path $destinationFile -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFile -Destination $destinationFile
