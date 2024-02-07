#
# chocolatey
#

# check if chocolatey is already installed
if (Get-Command choco -ErrorAction SilentlyContinue) {
  Write-Output "Chocolatey is already installed."
  return
}

# check if this is an admin shell
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Output "Please run this script as an administrator."
  return
}

# install chocolatey
Write-Output "Installing chocolatey..."

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# attaching chocolatey at the end of PATH
$env:Path += ";%ALLUSERSPROFILE%\chocolatey\bin"
