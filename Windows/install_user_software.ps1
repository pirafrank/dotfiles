
if (!(Get-Command scoop)){
  ## install scoop (running this as user)
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
  Invoke-RestMethod get.scoop.sh | Invoke-Expression

  # add scoop to Path (this to avoid opening a new shell session)
  $env:Path += ";$env:USERPROFILE\scoop\shims"
}

#
# buckets
#

# Add main bucket
scoop bucket add main
# Add the extras bucket
scoop bucket add extras
# Add bucket with multiple software versions
scoop bucket add versions
# Add Java bucket
scoop bucket add java
# Add Nirsoft bucket
scoop bucket add nirsoft https://github.com/kodybrown/scoop-nirsoft
# Add nerd-fonts bucket
scoop bucket add nerd-fonts https://github.com/matthewjberger/scoop-nerd-fonts
# Add bucket of non-portable software
scoop bucket add nonportable https://github.com/ScoopInstaller/Nonportable
# Add imgcat (https://github.com/danielgatis/imgcat) bucket
scoop bucket add scoop-imgcat https://github.com/danielgatis/scoop-imgcat.git
# Add bucket of unofficial distribution of Zed
scoop bucket add zed-unofficial https://github.com/pirafrank/zed_unofficial_win_builds.git

Write-Host "Currently installed the following buckets"
scoop bucket list


#
# software
#

# essential cli tools
scoop install `
  vim `
  fzf `
  fd `
  wget `
  curl `
  delta `
  lazygit `
  lazydocker `
  gh `
  bat `
  tere `
  jq `
  yq `
  less `
  rclone

# environments
scoop install `
  nvm `
  pyenv `
  go `
  deno `
  wasmer

# dev tools
scoop install `
  meld `
  insomnia `
  postman `
  mockoon

# desktop utils
scoop install `
  caffeine `
  sudo

# clone dotfiles
Set-Location "$env:USERPROFILE"
git clone https://github.com/pirafrank/dotfiles.git dotfiles

# create 'Code' dir
New-Item "$env:UserProfile\Code" -itemType Directory -Force
