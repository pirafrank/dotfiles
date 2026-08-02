function Initialize-Fnm {
    if ($script:FnmInitialized) { return }
    $script:FnmInitialized = $true

    if (Get-Command fnm -ErrorAction SilentlyContinue) {
        fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
    }

    foreach ($name in 'node', 'npm', 'npx', 'pnpm', 'yarn', 'corepack', 'fnm') {
        Remove-Item "function:global:$name" -Force -ErrorAction SilentlyContinue
    }
}
