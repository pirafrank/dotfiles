# PowerShell

- <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4>

## Install (PowerShell 7)

Symlink the profile to the PowerShell 7 profile location.

```powershell
function Invoke-Symlink($shortcutTarget, $shortcutName) {
    New-Item -Type SymbolicLink -Path "$shortcutName" -Target "$shortcutTarget"
}
Invoke-Symlink "$env:USERPROFILE\dotfiles\PowerShell\Profile.ps1" "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"
```
