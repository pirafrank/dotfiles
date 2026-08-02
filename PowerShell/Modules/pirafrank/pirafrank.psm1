function Write-BranchName {
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if (-not $branch) { return }

        if ($branch -eq "HEAD") {
            $branch = git rev-parse --short HEAD 2>$null
            Write-Host -NoNewline " ($branch)" -ForegroundColor "red"
        } else {
            Write-Host -NoNewline " ($branch)" -ForegroundColor "Gray"
        }
    } catch {
        Write-Host -NoNewline " (no branches yet)" -ForegroundColor "yellow"
    }
}

function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$(' ~' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    $inRepo = git rev-parse --is-inside-work-tree 2>$null
    if ($inRepo -eq "true") {
        Write-Host -NoNewline -ForegroundColor "cyan" $path
        Write-BranchName
    } else {
        Write-Host $path -NoNewline -ForegroundColor "cyan"
    }

    return $userPrompt
}

Export-ModuleMember -Function prompt, Write-BranchName
