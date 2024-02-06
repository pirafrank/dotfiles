
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
# Add bucket with multiple software versions
scoop bucket add versions
# Add Java bucket
scoop bucket add java
# Add bucket of NirSoft utilities
scoop bucket add nirsoft
# Add bucket of non-portable applications
scoop bucket add nonportable

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
  cwrsync `
  rclone

# additional CLI tools
scoop install `
  krew
# imgcat displays images and gifs in terminal
scoop bucket add scoop-imgcat https://github.com/danielgatis/scoop-imgcat.git
scoop install scoop-imgcat/imgcat

# environments
scoop install `
  nvm `
  pyenv `
  go `
  deno `
  wasmer

# dev tools w/ a GUI
scoop install `
  meld `
  insomnia `
  postman `
  mockoon `
  lens `
  dbeaver

# desktop utils
scoop install `
  caffeine `
  sudo

# clone dotfiles
Set-Location "$env:USERPROFILE"
git clone https://github.com/pirafrank/dotfiles.git dotfiles

# create 'Code' dir
New-Item "$env:UserProfile\Code" -itemType Directory -Force
