
#
# functions
#

function Invoke-Elevated ($scriptblock, [switch]$NoExit) {
  $sh = New-Object -Com 'Shell.Application'
  $command = "powershell"
  if ($NoExit) {
    $command += " -NoExit"
  }
  if ($scriptblock) {
    $command += " -Command $scriptblock"
  }
  $sh.ShellExecute($command, '', '', 'runas')
}

#
# main script
#

# Save current location to a variable
$StartLocation = $PWD.Path

Try {
  # get user's temp dir, this should be equivalent to: %USERPROFILE%\AppData\Local\Temp
  $TempDir = [System.IO.Path]::GetTempPath()
  Set-Location $TempDir

  # download dotfiles as zip archive
  $DotfilesUrl = "https://github.com/pirafrank/dotfiles/archive/refs/heads/main.zip"
  Invoke-RestMethod $DotfilesUrl -outfile dotfiles.zip

  # extract dotfiles
  $TempDotfilesDir = "$TempDir\dotfiles"
  if (-not (Test-Path -Path $TempDotfilesDir)) {
    New-Item -ItemType Directory -Path $TempDotfilesDir | Out-Null
  }
  Expand-Archive -Path "dotfiles.zip" -DestinationPath $TempDotfilesDir
}
Catch {
  Write-Verbose "[$((Get-Date).TimeofDay)] There was an error."
  Throw $_
}

# print current powershell version
$PSVersionTable
