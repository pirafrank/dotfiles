function gwl {
    git worktree list --porcelain | Select-String "^branch" | ForEach-Object {
        $_ -replace "branch ", "" -replace "refs/heads/", ""
    }
}
