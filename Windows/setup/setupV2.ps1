

#
# main script
#

# Save current location to a variable
$StartLocation = $PWD.Path

# print current powershell version
$PSVersionTable

Try {
  Start-Process powershell `
    -Wait `
    -Verb Runas `
    -ArgumentList "-NoExit", "-File $TempDotfilesDir\Windows\setup\install_winget.ps1"
  Start-Process powershell `
    -Wait `
    -Verb Runas `
    -ArgumentList "-NoExit", "-File $TempDotfilesDir\Windows\setup\install_chocolatey.ps1"
  Start-Process powershell `
    -Wait `
    -Verb Runas `
    -ArgumentList "-NoExit", "-File $TempDotfilesDir\Windows\setup\install_software.ps1"
}
Catch {
  Write-Verbose "[$((Get-Date).TimeofDay)] There was an error."
}

Try {
  Start-Process powershell `
    -Wait `
    -ArgumentList "-NoExit", "-File $TempDotfilesDir\Windows\setup\install_scoop.ps1"

  Start-Process powershell `
    -Wait `
    -ArgumentList "-NoExit", "-File $TempDotfilesDir\Windows\setup\install_user_software.ps1"
}
Catch {
  Write-Verbose "[$((Get-Date).TimeofDay)] There was an error."
}

if ($PSVersionTable.PSVersion.Major -ge 7) {
  refreshenv
}
else {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
}

# back to prev location
Set-Location $StartLocation
