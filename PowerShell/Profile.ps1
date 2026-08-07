# this is a comment, in case you forget how to make one!

$script:DotfilesRoot  = Join-Path $env:USERPROFILE 'dotfiles'
$script:FunctionsRoot = Join-Path $script:DotfilesRoot 'PowerShell\Functions'
$script:ModulesRoot   = Join-Path $script:DotfilesRoot 'PowerShell\Modules'

function Register-LazyCommand {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$SourceFile
    )
    $path = (Join-Path $script:FunctionsRoot $SourceFile) -replace "'", "''"
    $sb = [scriptblock]::Create(@"
param([Parameter(ValueFromRemainingArguments=`$true)][object[]]`$args)
. '$path'
Remove-Item 'function:global:$Name' -Force -ErrorAction SilentlyContinue
& '$Name' @args
"@)
    Set-Item "function:global:$Name" -Value $sb
}

function Register-LazyFnmCommand {
    param([Parameter(Mandatory)][string]$Name)
    $path = (Join-Path $script:FunctionsRoot 'fnm.ps1') -replace "'", "''"
    $sb = [scriptblock]::Create(@"
param([Parameter(ValueFromRemainingArguments=`$true)][object[]]`$args)
. '$path'
Initialize-Fnm
`$command = Get-Command '$Name' -CommandType Application -ErrorAction Stop | Select-Object -First 1
& `$command.Source @args
"@)
    Set-Item "function:global:$Name" -Value $sb
}

Set-Alias -Name man -Value Get-Help -Option AllScope
Set-Alias -Name dir -Value Get-ChildItem -Option AllScope
Set-Alias -Name l -Value ls -Option AllScope
Set-Alias -Name which -Value get-command -Option AllScope
Set-Alias lg lazygit
Set-Alias ldk lazydocker
Set-Alias -Name open -Value Invoke-Item -Option AllScope
Set-Alias -Name touch -Value New-Item -Option AllScope

Set-Alias k kubectl
Set-Alias dk docker

# override 'cat' alias to use 'bat' instead.
# removal is necessary because 'cat' is a built-in alias for Get-Content in pwsh
Remove-Item alias:cat -Force
Set-Alias -Name cat -Value bat -Option AllScope -Force

Set-Alias ll ls
Set-Alias g git
Set-Alias j just

# NOTE: do not set 'nv' as an alias for nvim,
#       because it conflicts with pwsh nv -> New-Variable built-in alias.

# additional aliases from zsh config
Set-Alias gitc git-crypt
Set-Alias ydl youtube-dl
Set-Alias py python
Set-Alias py3 python3

# git worktree aliases
Set-Alias gwb 'git worktree add -b'
Set-Alias gwr 'git worktree remove'
Set-Alias gwp 'git worktree prune'
Set-Alias gwre 'git worktree repair'

Register-LazyCommand -Name gg                -SourceFile 'gg.ps1'
Register-LazyCommand -Name gwl               -SourceFile 'gwl.ps1'
Register-LazyCommand -Name epoch             -SourceFile 'epoch.ps1'
Register-LazyCommand -Name today             -SourceFile 'today.ps1'
Register-LazyCommand -Name now               -SourceFile 'now.ps1'
Register-LazyCommand -Name myip              -SourceFile 'myip.ps1'
Register-LazyCommand -Name serve             -SourceFile 'serve.ps1'
Register-LazyCommand -Name npmlist           -SourceFile 'npmlist.ps1'
Register-LazyCommand -Name npmlistg          -SourceFile 'npmlistg.ps1'
Register-LazyCommand -Name Invoke-Symlink    -SourceFile 'Invoke-Symlink.ps1'
Register-LazyCommand -Name uptime            -SourceFile 'uptime.ps1'
Register-LazyCommand -Name cd2               -SourceFile 'cd2.ps1'
Register-LazyCommand -Name Get-Detailed-List -SourceFile 'Get-Detailed-List.ps1'
Register-LazyCommand -Name reload            -SourceFile 'reload.ps1'
Register-LazyCommand -Name yy                -SourceFile 'yy.ps1'
Set-Alias symlink Invoke-Symlink

# bat output style
$env:BAT_STYLE = "changes,header,numbers,snip"

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Set-Alias -Name cd -Value cd2 -Option AllScope
$Env:CDPATH = ".;C:\Users\francesco\Code"

# Lazy-load prompt module and Terminal-Icons on first render.
# Saves ~600ms+ at startup; one-time delay before first prompt.
function prompt {
    Import-Module (Join-Path $script:ModulesRoot 'pirafrank') -Force
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    Remove-Item function:global:prompt -Force -ErrorAction SilentlyContinue
    prompt
}

# Lazy-load PSFzf on first use of Ctrl+T, Ctrl+R, or Tab.
# Saves ~450ms at startup; one-time delay on first fzf keypress.
function _InitPsFzf {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
        -PSReadlineChordReverseHistory 'Ctrl+r'
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    Remove-Item function:_InitPsFzf -ErrorAction SilentlyContinue
}
if (-not $script:PsFzfHandlersRegistered) {
    $script:PsFzfHandlersRegistered = $true
    Set-PSReadLineKeyHandler -Key 'Ctrl+t' -ScriptBlock { _InitPsFzf; Invoke-FzfProvider }
    Set-PSReadLineKeyHandler -Key 'Ctrl+r' -ScriptBlock { _InitPsFzf; Invoke-FzfReverseHistoryProvider }
    Set-PSReadLineKeyHandler -Key Tab      -ScriptBlock { _InitPsFzf; Invoke-FzfTabCompletion }
}

# Lazy-load ZLocation on first use of 'z'.
# install by running: Install-Module -Name ZLocation -Repository PSGallery
# Saves ~635ms at startup; one-time delay on first 'z' call.
function z {
    Remove-Item function:z -ErrorAction SilentlyContinue
    Import-Module ZLocation -ErrorAction SilentlyContinue
    z @args
}

#
# Windows-only
#
if ($env:OS -like "*Windows*") {
    Register-LazyCommand -Name Invoke-Here -SourceFile 'Invoke-Here.ps1'
    Set-Alias here Invoke-Here

    Register-LazyCommand -Name Invoke-Tere -SourceFile 'Invoke-Tere.ps1'
    Set-Alias tere Invoke-Tere

    Register-LazyCommand -Name java8 -SourceFile 'java.ps1'
    Register-LazyCommand -Name java11 -SourceFile 'java.ps1'
    Register-LazyCommand -Name java16 -SourceFile 'java.ps1'
    Register-LazyCommand -Name java17 -SourceFile 'java.ps1'

    # Lazy-load Chocolatey tab-completion on first 'choco' call.
    $global:_chocoProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path $global:_chocoProfile) {
        function choco {
            Remove-Item function:choco -ErrorAction SilentlyContinue
            Import-Module $global:_chocoProfile
            choco @args
        }
    }

    # ~/bin is symlinked to dotfiles/Windows/bin by install_dotfiles.ps1.
    # Prepend only if the symlink exists and is not already on PATH.
    $binLink = Join-Path $env:USERPROFILE 'bin'
    if ((Test-Path $binLink) -and $env:Path -notlike "*$binLink*") {
        $env:Path = "$binLink$([IO.Path]::PathSeparator)$env:Path"
    }
}

# Lazy-load fnm on first Node-related command.
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    foreach ($cmd in 'node', 'npm', 'npx', 'pnpm', 'yarn', 'corepack', 'fnm') {
        Register-LazyFnmCommand -Name $cmd
    }
}

# only initialize conda if no virtualenv is active and python is not managed by pyenv-win
# if ($IsWindows -and -not $env:VIRTUAL_ENV) {
#     $pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source
#     if ($pythonPath -and $pythonPath -like "*AppData\Local\Programs\Python*") {
#       If (Test-Path "C:\Users\francesco\anaconda3\Scripts\conda.exe") {
#           (& "C:\Users\francesco\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
#       }
#     }
# }
