# Neofetch

<https://github.com/dylanaraps/neofetch>

## Docs

<https://github.com/dylanaraps/neofetch/wiki>

## Installation

```sh
mkdir -p "$HOME/.local/src/neofetch"
cd "$HOME/.local/src/neofetch"
wget https://github.com/dylanaraps/neofetch/archive/refs/tags/7.1.0.zip
unzip neofetch-7.1.0.zip
cd neofetch-7.1.0
sudo make install
```

## Configuration

*Nix

```sh
mkdir -p "$HOME/.config/neofetch"
ln -s "$HOME/dotfiles/neofetch/config.conf" "$HOME/.config/neofetch/config.conf"
```

Windows

```powershell
mkdir $env:USERPROFILE\.config\neofetch
New-Item -Type SymbolicLink -Path "$env:USERPROFILE\.config\neofetch\config.conf" -Target "$env:USERPROFILE\dotfiles\neofetch\config.conf"
```
