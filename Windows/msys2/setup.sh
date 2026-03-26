#!/usr/bin/env bash
# Setup script for the minimal MSYS2 zsh environment.
# Run once from an MSYS2 UCRT64 (or MINGW64) terminal:
#
#   bash "$USERPROFILE/dotfiles/Windows/msys2/setup.sh"
#
# What it does:
#   1. Installs required pacman packages (zsh, git, curl, man, bat, zoxide, fzf)
#   2. Clones powerlevel10k standalone to ~/powerlevel10k
#   3. Creates ~/.zshrc -> this repo's Windows/msys2/zshrc
#   4. Creates ~/.p10k.zsh -> this repo's zsh/common/p10k.zsh (reuse existing)
#
# To make zsh the default shell for an environment, add this line to its .ini
# file (e.g. C:\msys64\ucrt64.ini):
#   SHELL=/usr/bin/zsh

set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
info()  { printf '\e[34m[info]\e[0m  %s\n' "$*"; }
ok()    { printf '\e[32m[ok]\e[0m    %s\n' "$*"; }
warn()  { printf '\e[33m[warn]\e[0m  %s\n' "$*"; }
err()   { printf '\e[31m[error]\e[0m %s\n' "$*" >&2; }

backup_if_exists() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak"
    warn "Backed up existing $(basename "$target") -> ${target}.bak"
  elif [[ -L "$target" ]]; then
    rm "$target"
  fi
}

# ---------------------------------------------------------------------------
# Resolve dotfiles path
# USERPROFILE is set by MSYS2 from the Windows environment.
# cygpath converts it to a POSIX path usable inside MSYS2.
# ---------------------------------------------------------------------------
if [[ -z "${USERPROFILE:-}" ]]; then
  err "USERPROFILE is not set. Are you running this inside MSYS2?"
  exit 1
fi
DOTFILES="$(cygpath -u "$USERPROFILE")/dotfiles"

if [[ ! -d "$DOTFILES" ]]; then
  err "Dotfiles directory not found at: $DOTFILES"
  err "Clone your dotfiles repo to %USERPROFILE%\\dotfiles first."
  exit 1
fi
info "Dotfiles found at: $DOTFILES"

# ---------------------------------------------------------------------------
# 1. Install pacman packages
# ---------------------------------------------------------------------------
info "Installing packages via pacman..."

PACKAGES=(
  zsh
  git
  curl
  man-db
)

# Optional but recommended (only install if pacman knows about them)
OPTIONAL_PACKAGES=(
  bat
  zoxide
  vim
  the_silver_searcher  # ag
)

# Core packages — fail loudly if any are missing
pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Optional packages — warn but continue if not found
for pkg in "${OPTIONAL_PACKAGES[@]}"; do
  if pacman -Si "$pkg" &>/dev/null; then
    pacman -S --needed --noconfirm "$pkg"
  else
    warn "Optional package '$pkg' not found in current repos — skipping"
  fi
done

# NOTE: fzf, fd, bat, lazygit, neovim are expected to be installed
# via Scoop on Windows and reachable through the inherited PATH.
# To install them via pacman instead:
#   pacman -S mingw-w64-ucrt-x86_64-fzf mingw-w64-ucrt-x86_64-fd
#   pacman -S mingw-w64-ucrt-x86_64-bat mingw-w64-ucrt-x86_64-lazygit

ok "Packages installed."

# ---------------------------------------------------------------------------
# 2. Install powerlevel10k standalone
# ---------------------------------------------------------------------------
P10K_DIR="$HOME/powerlevel10k"
if [[ -d "$P10K_DIR/.git" ]]; then
  info "powerlevel10k already installed at $P10K_DIR — updating..."
  git -C "$P10K_DIR" pull --rebase --autostash
else
  info "Cloning powerlevel10k to $P10K_DIR..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
ok "powerlevel10k ready."

# ---------------------------------------------------------------------------
# 3. Symlink ~/.zshrc
# ---------------------------------------------------------------------------
info "Linking ~/.zshrc..."
backup_if_exists "$HOME/.zshrc"
ln -s "$DOTFILES/Windows/msys2/zshrc" "$HOME/.zshrc"
ok "~/.zshrc -> $DOTFILES/Windows/msys2/zshrc"

# ---------------------------------------------------------------------------
# 4. Symlink ~/.p10k.zsh (reuse the full dotfiles p10k config)
# p10k silently hides segments for tools that are not installed,
# so the existing config works without modification on MSYS2.
# ---------------------------------------------------------------------------
info "Linking ~/.p10k.zsh..."
backup_if_exists "$HOME/.p10k.zsh"
ln -s "$DOTFILES/zsh/common/p10k.zsh" "$HOME/.p10k.zsh"
ok "~/.p10k.zsh -> $DOTFILES/zsh/common/p10k.zsh"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
ok "Setup complete. Run: exec zsh"
echo ""
echo "  To make zsh the default shell for UCRT64, add this line to"
echo "  C:\\msys64\\ucrt64.ini (adjust path if MSYS2 is installed elsewhere):"
echo ""
echo "    SHELL=/usr/bin/zsh"
echo ""
echo "  First run: p10k will prompt you to configure the prompt."
echo "  To reconfigure later: p10k configure"
echo ""
echo "  Tip: install lazygit via Scoop on Windows (scoop install lazygit)"
echo "  and it will be available here through the inherited PATH."
