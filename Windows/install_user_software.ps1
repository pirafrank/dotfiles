
if (!(Get-Command scoop)){
  ## install scoop (running this as user)
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
  Invoke-RestMethod get.scoop.sh | Invoke-Expression

  # add scoop to Path (this to avoid opening a new shell session)
  $env:Path += ";$env:USERPROFILE\scoop\shims"
}

# Add main bucket
scoop bucket add main
# Add the extras bucket
scoop bucket add extras

# Installing scoop software in current user session
scoop install lazygit bat tere jq yq less

# clone dotfiles
Set-Location "$env:USERPROFILE"
git clone https://github.com/pirafrank/dotfiles.git dotfiles

# create 'Code' dir
New-Item "$env:UserProfile\Code" -itemType Directory -Force
