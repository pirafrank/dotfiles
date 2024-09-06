$sourceFolder = "$env:USERPROFILE\AppData\Local\Packages\7061touchwp.CustomContextMenu_m9vp3t2f55f5t\LocalState\custom_commands"
$destinationFolder = ".\custom_commands"

# Check if the destination directory exists and delete it if it does
if (Test-Path $destinationFolder) {
  Remove-Item -Path $destinationFolder -Recurse -Force
}

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFolder -Destination $destinationFolder -Recurse

