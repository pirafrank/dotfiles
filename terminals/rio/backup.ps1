$sourceFile = "$env:USERPROFILE\AppData\Local\rio\config.toml"
$destinationFile = ".\config_wsl.toml"

# Check if the destination directory exists and delete it if it does
if (Test-Path $destinationFile) {
  Remove-Item -Path $destinationFile -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFile -Destination $destinationFile

