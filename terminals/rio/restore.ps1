$sourceFile = ".\config_wsl.toml"
$destinationFile = "$env:USERPROFILE\AppData\Local\rio\config.toml"

# Check if the destination directory exists and delete it if it does
if (Test-Path $destinationFile) {
  Remove-Item -Path $destinationFile -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFile -Destination $destinationFile

