#
# check_psmodule_updates.ps1
#
# Check for updated versions of user installed PowerShell modules.
#
# First version published as gist here:
# https://gist.github.com/pirafrank/b8cbe1b2a7d1e0563ff2543c24d88d64
#
# Author: github.com/pirafrank
#

# get listed of user installed PowerShell modules
$installedModules = Get-ChildItem -Path "$env:USERPROFILE\Documents\PowerShell\Modules" -Directory | Select-Object Name

# process each result and create row object
$results = foreach ($module in $installedModules) {
    $currentVersion = (Get-Module -Name $module.Name -ListAvailable).Version
    $onlineVersion = (Find-Module -Name $module.Name -ErrorAction SilentlyContinue).Version

    [PSCustomObject]@{
        Name = $module.Name
        CurrentVersion = $currentVersion
        AvailableVersion = $onlineVersion
        UpdateAvailable = if ($onlineVersion -gt $currentVersion) { $true } else { $false }
    }
}

# present results as table
$results | Format-Table -AutoSize -Wrap


#
# Notes:
# useful stock powershell commands to use this script with:
#
#
# Update-Module -Name "ModuleName"
#
# Install-Module -Name "ModuleName" -RequiredVersion "X.Y.Z" -Force
#
# Uninstall-Module -Name "ModuleName"
#
# Uninstall-Module -Name "ModuleName" -RequiredVersion "X.Y.Z"
#
# Get-InstalledModule -Name "ModuleName" -AllVersions
#
# Get-InstalledModule -Name "ModuleName" -AllVersions | Uninstall-Module
#
# Uninstall-Module -Name "ModuleName" -Force
#
