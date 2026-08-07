[CmdletBinding()]
param(
    [string] $ConfigDirectory
)

$ErrorActionPreference = 'Stop'

# Install the Nushell configuration from this repository. Existing targets
# are preserved as <name>.YYYY-MM-DD_HHmmss.bkp before linking.
$sourceDirectory = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path | Join-Path -ChildPath 'nushell'
if ([string]::IsNullOrWhiteSpace($ConfigDirectory)) {
    $ConfigDirectory = Join-Path $env:APPDATA 'nushell'
}
$ConfigDirectory = [System.IO.Path]::GetFullPath($ConfigDirectory)
$timestamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'

function Get-ExistingItem {
    param([Parameter(Mandatory)][string] $Path)

    return Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
}

function Backup-Target {
    param([Parameter(Mandatory)][string] $Path)

    $backupPath = "$Path.$timestamp.bkp"
    $counter = 1
    while (Get-ExistingItem -Path $backupPath) {
        $backupPath = "$Path.$timestamp`_$counter.bkp"
        $counter++
    }

    Write-Host "Backing up $Path -> $backupPath"
    Move-Item -LiteralPath $Path -Destination $backupPath
}

function Test-IsExpectedLink {
    param(
        [Parameter(Mandatory)][System.IO.FileInfo] $Item,
        [Parameter(Mandatory)][string] $Source
    )

    if ($Item.LinkType -ne 'SymbolicLink') { return $false }

    try {
        $actual = (Resolve-Path -LiteralPath $Item.FullName).Path
        $expected = (Resolve-Path -LiteralPath $Source).Path
        return $actual -eq $expected
    } catch {
        return $false
    }
}

function Install-SymbolicLink {
    param(
        [Parameter(Mandatory)][string] $Source,
        [Parameter(Mandatory)][string] $Target
    )

    $existing = Get-ExistingItem -Path $Target
    if ($existing -and (Test-IsExpectedLink -Item $existing -Source $Source)) {
        Write-Host "Already linked: $Target"
        return
    }

    if ($existing) {
        Backup-Target -Path $Target
    }

    Write-Host "Linking $Target -> $Source"
    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    } catch {
        throw "Unable to create the symbolic link $Target. Enable Windows Developer Mode or run PowerShell with permission to create symbolic links, then retry. Details: $($_.Exception.Message)"
    }
}

$requiredFiles = @('env.nu', 'config.nu')
foreach ($file in $requiredFiles) {
    $source = Join-Path $sourceDirectory $file
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Nushell configuration file not found: $source"
    }
}

New-Item -ItemType Directory -Path $ConfigDirectory -Force | Out-Null
Install-SymbolicLink -Source (Join-Path $sourceDirectory 'env.nu') -Target (Join-Path $ConfigDirectory 'env.nu')
Install-SymbolicLink -Source (Join-Path $sourceDirectory 'config.nu') -Target (Join-Path $ConfigDirectory 'config.nu')

Write-Host ""
Write-Host "Nushell configuration installed."
Write-Host "Config directory: $ConfigDirectory"
Write-Host 'Reload Nushell with: source $nu.config-path'
