function Initialize-Fnm {
    if ($script:FnmInitialized) { return }
    $script:FnmInitialized = $true

    # fnm is itself lazy-wrapped by the profile. Resolve the real executable
    # before invoking it, otherwise fnm env recurses into this wrapper.
    $fnmExecutable = Get-Command fnm -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($fnmExecutable) {
        & $fnmExecutable.Source env --use-on-cd --shell powershell |
            Out-String | Invoke-Expression
    }

    foreach ($name in 'node', 'npm', 'npx', 'pnpm', 'yarn', 'corepack', 'fnm') {
        Remove-Item "function:global:$name" -Force -ErrorAction SilentlyContinue
    }
}
