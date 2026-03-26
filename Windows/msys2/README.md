# Minimal zsh for MSYS2 on Windows 11

A lightweight zsh config for MSYS2 (UCRT64 or MINGW64) — intended as a
comfortable shell for git work and general CLI tasks on Windows, while the
full dotfiles setup lives in WSL2.

No Oh-My-Zsh, no zprezto, no plugin manager. Powerlevel10k is installed
standalone. Everything else is either a pacman package or available through
the inherited Windows PATH (Scoop).

## Prerequisites

### MSYS2

Download and install from [msys2.org](https://www.msys2.org). During first
run, update the base system:

```bash
pacman -Syu
# close the terminal when asked, reopen, then:
pacman -Su
```

Use the **UCRT64** environment (the shortcut labelled "MSYS2 UCRT64" in the
Start menu). It has the best compatibility with modern Windows tooling.

### Scoop (Windows-side)

Several tools (`lazygit`, `fzf`, `fd`, `bat`, `neovim`) are expected to be
installed via [Scoop](https://scoop.sh) on the Windows side and are
accessible inside MSYS2 through the inherited `PATH`. If you already ran
`Windows/install_user_software.ps1`, they are already present.

To install Scoop and the relevant tools manually:

```powershell
# In PowerShell (user, no admin needed)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod get.scoop.sh | Invoke-Expression

scoop install git lazygit fzf fd bat neovim zoxide
```

### Dotfiles repo

The dotfiles repo must be cloned to `%USERPROFILE%\dotfiles`
(`C:\Users\<you>\dotfiles`). The setup script resolves that path
automatically via `cygpath`.

```powershell
git clone https://github.com/pirafrank/dotfiles "$env:USERPROFILE\dotfiles"
```

---

## Setup

Open the **MSYS2 UCRT64** terminal and run:

```bash
bash "$USERPROFILE/dotfiles/Windows/msys2/setup.sh"
```

The script will:

1. Install core pacman packages: `zsh`, `git`, `curl`, `man-db`, `bat`,
   `zoxide`, `vim`
2. Clone [powerlevel10k](https://github.com/romkatv/powerlevel10k) to
   `~/powerlevel10k`
3. Symlink `~/.zshrc` → `dotfiles/Windows/msys2/zshrc`
4. Symlink `~/.p10k.zsh` → `dotfiles/zsh/common/p10k.zsh`
5. Optionally set zsh as the default MSYS2 shell via `chsh`

After setup, start zsh:

```bash
exec zsh
```

On the first launch, powerlevel10k will walk you through prompt
configuration. Your answers are written to `~/.p10k.zsh` (which is
symlinked to the shared config in the dotfiles repo, so keep that in mind
if you also use the full setup on WSL2/Linux — consider running
`p10k configure` separately on each platform if the outputs differ).

---

## What's included

| Feature | Detail |
|---|---|
| **Prompt** | Powerlevel10k — reuses `zsh/common/p10k.zsh`. Segments for tools not installed are hidden automatically. |
| **Completion** | zsh native `compinit` |
| **Fuzzy search** | fzf with `fd` backend and `bat` preview (`fp` alias) |
| **Smart cd** | zoxide (`z`, `zi`) |
| **Git aliases** | `gg`, `gitc`, `lg` (lazygit), full worktree suite (`gwa`, `gwj`, `gwb`, `gwr`, `gwl`, `gwp`, `gwre`) |
| **bat** | replaces `cat` with syntax highlighting |
| **Windows interop** | `open` → `explorer.exe`, `clip` → `clip.exe` |
| **mkcd** | `mkdir` + `cd` in one command |
| **dotup** | pull latest dotfiles from git |
| **tmux aliases** | `main`, `work`, `tat`, `tm_kill` |
| **Local overrides** | `~/.zsh_custom` sourced if present |

---

## Configuration

### Prompt

The prompt reuses the existing `zsh/common/p10k.zsh`. To reconfigure it
for MSYS2 specifically (different segments, icon set, etc.), run:

```zsh
p10k configure
```

This overwrites `~/.p10k.zsh`. Since that file is a symlink into the
dotfiles repo, the change will affect all platforms sharing the same
config. If you want MSYS2-specific prompt settings, break the symlink
first:

```bash
cp --remove-destination "$(readlink ~/.p10k.zsh)" ~/.p10k.zsh
```

Then edit `~/.p10k.zsh` freely — it is now a plain file local to MSYS2.

### Local overrides

Any machine-specific aliases, env vars, or PATH additions that should not
live in the repo go in `~/.zsh_custom`. That file is sourced at the end of
`zshrc` if it exists.

### Adding more tools from pacman

Scoop tools are preferred to avoid package duplication, but you can install
pacman versions instead. For UCRT64:

```bash
# fzf, fd, bat, lazygit via pacman (UCRT64 package names)
pacman -S mingw-w64-ucrt-x86_64-fzf
pacman -S mingw-w64-ucrt-x86_64-fd
pacman -S mingw-w64-ucrt-x86_64-bat
pacman -S mingw-w64-ucrt-x86_64-lazygit
```

If both a Scoop and a pacman version are installed, the MSYS2 PATH puts
pacman binaries (`/ucrt64/bin`, `/usr/bin`) ahead of the inherited Windows
PATH, so the pacman version wins.

### Sharing SSH keys and git config with Windows

MSYS2 home defaults to `/home/<username>` (separate from
`C:\Users\<username>`). If you want to share your SSH keys and git config
between MSYS2 and native Windows tools without copying files, add these
symlinks:

```bash
WINHOME="$(cygpath -u "$USERPROFILE")"

# git config
ln -s "$WINHOME/.gitconfig" ~/.gitconfig

# SSH keys
ln -s "$WINHOME/.ssh" ~/.ssh
```

Run this once manually or add it to `setup.sh` for your machine.

---

## Updating

Pull the latest dotfiles (both inside MSYS2 and on the Windows side point
to the same repo directory, so one pull is enough):

```zsh
dotup
```

To update powerlevel10k:

```bash
git -C ~/powerlevel10k pull --rebase --autostash
```

---

## Troubleshooting

**`cygpath: command not found`**

You are not running inside MSYS2. Open the MSYS2 UCRT64 terminal.

**p10k shows boxes instead of icons**

Install a Nerd Font and configure it in Windows Terminal. Recommended:
`MesloLGS NF` (linked from the p10k repo) or any other Nerd Font already
in use in your Windows Terminal profile.

**`lazygit` / `fzf` / `bat` not found**

These are expected via Scoop (inherited PATH). Verify with:

```bash
which lazygit   # should print something under /c/Users/<you>/scoop/shims/
```

If not found, either install via Scoop or install the pacman equivalent
(see "Adding more tools from pacman" above).

**zsh not launching by default**

MSYS2 doesn't use `chsh`. Set the default shell by adding one line to the
environment's `.ini` file. For UCRT64, open
`C:\msys64\ucrt64.ini` in a text editor and add:

```ini
SHELL=/usr/bin/zsh
```

Then close and reopen the MSYS2 UCRT64 terminal.
