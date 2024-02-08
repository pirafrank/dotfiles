
$now = Get-Date -Format "yyyyMMdd_HHmmss"

if(!(Test-Path -Path "$env:USERPROFILE\.config\lf")) {
  New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\lf"
}

if(Test-Path -Path "$env:USERPROFILE\.config\lf\lfrc") {
  Move-Item -Path "$env:USERPROFILE\.config\lf\lfrc" -Destination "$env:USERPROFILE\.config\lf\lfrc_$now"
}

symlink "$env:USERPROFILE\dotfiles\lf\lfrc" "$env:USERPROFILE\.config\lf\lfrc"
symlink "$env:USERPROFILE\dotfiles\lf\icons" "$env:USERPROFILE\.config\lf\icons"
