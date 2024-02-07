
# check if scoop is installed
if (-not (Test-Path -Path $env:USERPROFILE\scoop)) {
  # install scoop
  Write-Host "Scoop must be installed first."
  return
}

#
# Install scoop provided packages
#

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
  neovim `
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

# terminals
scoop install `
  alacritty `
  wezterm

# environments
scoop install `
  nvm `
  pyenv `
  go `
  rust `
  rustup `
  deno `
  wasmer

# dev tools
scoop install `
  mongodb-compass `
  mongodb-database-tools `
  mongosh `
  robo-3t `
  redis-desktop-manager `
  meld `
  insomnia `
  postman `
  mockoon `
  lens `
  dbeaver

# desktop utils
scoop install `
  element `
  typora `
  vncviewer

# additional desktop utils
scoop install `
  caffeine `
  sudo
