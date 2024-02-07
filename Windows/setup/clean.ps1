# get user's temp dir, this should be equivalent to: %USERPROFILE%\AppData\Local\Temp
$TempDir = [System.IO.Path]::GetTempPath()
Remove-Item -Path "$TempDir\dotfiles.zip" -Force
Remove-Item -Path "$TempDir\dotfiles" -Recurse -Force
