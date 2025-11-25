# this is a comment, in case you forget how to make one!

Set-Alias -Name man -Value Get-Help -Option AllScope
Set-Alias -Name dir -Value Get-ChildItem -Option AllScope
Set-Alias -Name l -Value ls -Option AllScope
Set-Alias which get-command
Set-Alias lg lazygit
Set-Alias ldk lazydocker
Set-Alias open Invoke-Item
Set-Alias touch New-Item

Set-Alias k kubectl
Set-Alias dk docker
Set-Alias cat bat
Set-Alias ll ls
Set-Alias g git

# bat output style
$env:BAT_STYLE="changes,header,numbers,snip"

# symlink alias
function Invoke-Symlink($shortcutTarget, $shortcutName) {
    New-Item -Type SymbolicLink -Path "$shortcutName" -Target "$shortcutTarget"
}
Set-Alias symlink Invoke-Symlink

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# customized prompt with git integration
# source: https://bit.ly/3f1JjC5

function uptime () {
    Get-Uptime -Since # powershell >= 6
    # Get-CimInstance -ClassName Win32_OperatingSystem | Select LastBootUpTime # powershell =< 5
}

function Write-BranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host -NoNewline " ($branch)" -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            Write-Host -NoNewline " ($branch)" -ForegroundColor "Gray"
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host -NoNewline " (no branches yet)" -ForegroundColor "yellow"
    }
}

# customize prompt by overriding the 'prompt' function
function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$(' ~' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    if (Test-Path .git) {
        Write-Host -NoNewline -ForegroundColor "cyan" $path
        Write-BranchName
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        Write-Host $path -NoNewline -ForegroundColor "cyan"
    }

    return $userPrompt
}

# CDPATH equivalent in PowerShell
# https://stackoverflow.com/questions/7236594/cdpath-functionality-in-powershell
function cd2 {
    param($path)
    if(-not $path){return;}

    if((test-path $path) -or (-not $env:CDPATH)){
        Set-Location $path
        return
    }
    $cdpath = $env:CDPATH.split(";") | % { $ExecutionContext.InvokeCommand.ExpandString($_) }
    $npath = ""
    foreach($p in $cdpath){
        $tpath = join-path $p $path
        if(test-path $tpath){$npath = $tpath; break;}
    }
    if($npath){
        #write-host -fore yellow "Using CDPATH"
        Set-Location $npath
        return
    }
    set-location $path
}
set-alias -Name cd -value cd2 -Option AllScope
# then set values like this $Env:CDPATH = ".;C:\Users\francesco\Code"
$Env:CDPATH = ".;C:\Users\francesco\Code"

# dir equivalent with target of symbolic links
function Get-Detailed-List([string]$path){
    Get-ChildItem $path -recurse -force | Where-Object{$_.LinkType} | Select-Object FullName,LinkType,Target
}

function reload {
    . $profile
    Write-Host "$profile loaded in session."
}

# import fzf
Import-Module PSFzf
# Override PSReadLine's history search
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                -PSReadlineChordReverseHistory 'Ctrl+r'
# Override default tab completion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

# load Terminal-Icons module
# install by running: Install-Module -Name Terminal-Icons -Repository PSGallery
if (Get-Module -ListAvailable -Name Terminal-Icons) { Import-Module -Name Terminal-Icons }

# install ZLocation (like fasd, but for PowerShell)
# install by running: Install-Module -Name ZLocation -Repository PSGallery
if (Get-Module -ListAvailable -Name ZLocation) { Import-Module -Name ZLocation }

#
# Windows-only scripts
#
# PowerShell (!WindowsPowerShell) has been designed to be cross-platform.
# Although it is very likely I won't run PowerShell on Linux and macOS,
# I don't like to bind PowerShell config to Windows-specific scripts that
# won't work on other platforms. Scripts in this file are Windows-only and
# should not be sourced by PowerShell on platforms other than Windows.
if ($env:OS -like "*Windows*") {

  function Invoke-Here() { explorer.exe . }
  Set-Alias here Invoke-Here

  # Chocolatey profile
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
  }

  # source dotfiles scripts
  # this sources every powershell script in dir
  $Path = "$env:USERPROFILE\dotfiles\Windows\scripts"
  Get-ChildItem -Path $Path -Filter *.ps1 | ForEach-Object {
    . $_.FullName
  }

  # add Windows\bin to $PATH.
  # keep this line at the very bottom.
  $Path = "$env:USERPROFILE\dotfiles\Windows\bin"
}

# fnm set node env on cd
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

function yy {
  $tmp = [System.IO.Path]::GetTempFileName()
  yazi $args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp
  if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
    Set-Location -LiteralPath $cwd
  }
  Remove-Item -Path $tmp
}

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\francesco\anaconda3\Scripts\conda.exe") {
    (& "C:\Users\francesco\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

