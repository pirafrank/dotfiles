# CDPATH equivalent in PowerShell
# https://stackoverflow.com/questions/7236594/cdpath-functionality-in-powershell
function cd2 {
    param($path)
    if (-not $path) {
        Set-Location $HOME
        return
    }

    if ((Test-Path $path) -or (-not $env:CDPATH)) {
        Set-Location $path
        return
    }
    $cdpath = $env:CDPATH.Split(";") | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }
    $npath = ""
    foreach ($p in $cdpath) {
        $tpath = Join-Path $p $path
        if (Test-Path $tpath) { $npath = $tpath; break }
    }
    if ($npath) {
        Set-Location $npath
        return
    }
    Set-Location $path
}
