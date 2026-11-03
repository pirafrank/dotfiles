function codex-enterprise {
    $homePath = Join-Path $HOME '.codex-enterprise'
    if (-not (Test-Path -LiteralPath $homePath)) {
        $null = New-Item -ItemType Directory -Path $homePath -Force
    }

    $previousHome = [Environment]::GetEnvironmentVariable('CODEX_HOME', 'Process')
    try {
        $env:CODEX_HOME = $homePath
        & codex @args
    }
    finally {
        [Environment]::SetEnvironmentVariable('CODEX_HOME', $previousHome, 'Process')
    }
}
