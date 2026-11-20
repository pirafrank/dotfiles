$ErrorActionPreference = 'Stop'

$configSource = Join-Path $PSScriptRoot 'config_wsl.toml'
$herdrDirectory = Join-Path $env:APPDATA 'herdr'
$configDestination = Join-Path $herdrDirectory 'config.toml'

if (-not (Test-Path -LiteralPath $configSource -PathType Leaf)) {
    throw "Herdr config not found: $configSource"
}

New-Item -ItemType Directory -Path $herdrDirectory -Force | Out-Null

if (Test-Path -LiteralPath $configDestination) {
    $existing = Get-Item -LiteralPath $configDestination -Force
    if ($existing.LinkType -eq 'SymbolicLink' -and
        [System.IO.Path]::GetFullPath($existing.Target) -eq [System.IO.Path]::GetFullPath($configSource)) {
        Write-Output "Herdr config symlink already points to $configSource"
        exit 0
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupPath = "$configDestination.$timestamp.bak"
    Move-Item -LiteralPath $configDestination -Destination $backupPath
    Write-Output "Existing config backed up to $backupPath"
}

New-Item -ItemType SymbolicLink -Path $configDestination -Target $configSource | Out-Null
Write-Output "Linked $configDestination to $configSource"

