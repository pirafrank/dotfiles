function zed {
  $exePath = "$env:USERPROFILE\AppData\Local\Programs\Zed\zed.exe"
  $arguments = $args -join " "
  Start-Process -FilePath $exePath -ArgumentList $arguments
}
