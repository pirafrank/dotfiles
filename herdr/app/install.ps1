$ErrorActionPreference = 'Stop'

$coreSource = Join-Path $PSScriptRoot 'core\config_wsl.toml'
$settingsSource = Join-Path $PSScriptRoot 'app\settings.json'
$keysSource = Join-Path $PSScriptRoot 'app\keys.json'
$coreDirectory = Join-Path $env:APPDATA 'herdr-core'
$appDirectory = Join-Path $env:USERPROFILE '.config\herdr-app'

function Install-ConfigFile {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "Herdr config not found: $Source"
    }

    $destinationDirectory = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null

    if (Test-Path -LiteralPath $Destination -PathType Leaf) {
        $sourceHash = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
        $destinationHash = (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
        if ($sourceHash -eq $destinationHash) {
            Write-Output "Already installed: $Destination"
            return
        }
    }

    if (Test-Path -LiteralPath $Destination) {
        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backup = "$Destination.$timestamp.bak"
        $suffix = 1
        while (Test-Path -LiteralPath $backup) {
            $backup = "$Destination.$timestamp-$suffix.bak"
            $suffix++
        }
        Move-Item -LiteralPath $Destination -Destination $backup
        Write-Output "Backed up existing file to $backup"
    }

    Copy-Item -LiteralPath $Source -Destination $Destination
    Write-Output "Installed $Destination"
}

Install-ConfigFile -Source $coreSource -Destination (Join-Path $coreDirectory 'config.toml')
Install-ConfigFile -Source $settingsSource -Destination (Join-Path $appDirectory 'settings.json')
Install-ConfigFile -Source $keysSource -Destination (Join-Path $appDirectory 'keys.json')
