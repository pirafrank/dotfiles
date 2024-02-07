
# check if scoop is installed before trying to install
if (!(Get-Command scoop)) {
  ## install scoop (running this as user)
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
  Invoke-RestMethod get.scoop.sh | Invoke-Expression

  # add scoop to Path (this to avoid opening a new shell session)
  $env:Path += ";$env:USERPROFILE\scoop\shims"
}
