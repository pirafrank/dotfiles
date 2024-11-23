$sourceFolder = ".\custom_commands"
$destinationFolder = "$env:USERPROFILE\AppData\Local\Packages\7061touchwp.CustomContextMenu_m9vp3t2f55f5t\LocalState\"

# Copy the source folder and its contents to the destination
Copy-Item -Path $sourceFolder -Destination $destinationFolder -Recurse -Force
