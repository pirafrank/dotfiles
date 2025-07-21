Copy-Item -Force -Recurse $env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets $env:USERPROFILE\Pictures\LockScreen_Wallpapers
Dir $env:USERPROFILE\Pictures\LockScreen_Wallpapers | rename-item -newname { [io.path]::ChangeExtension($_.name, "jpg") }
explorer $env:USERPROFILE\Pictures\LockScreen_Wallpapers
