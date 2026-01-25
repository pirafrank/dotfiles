# dotfiles

My dotfiles, simple as that.

This repo is a never-ending WIP. It's not meant to be sensible for everybody, or anyone, as YMMV. But I hope it may be useful to you somehow.

## Supported platforms

Linux, macOS and Windows are supported.

Debian-based distros and macOS 13+ are preferred. Designed to run ZSH in modern terminals (24-bit colors, ligatures, GPU rendering, etc.) with Nerd Fonts.

### Tested on

My daily drivers currently are Wezterm/Rio/Alacritty + ZSH running on:

- Ubuntu 24.04 WSL 2 on Windows 11 (was Ubuntu 20.04, was Ubuntu 22.04)
- Debian 13 (trixie) 'devbox' LXC container (via SSH)
- macOS 14 (Sonoma) via SSH
- PowerShell 7 on Windows 11 (24H2)

I also less frequently use:

- Debian 12 (bookworm) mini pc
- Ubuntu 22.04 desktop
- macOS 13 (Ventura) MacBook Air (Intel)
- GitHub Codespaces (`install.sh` defaults to this if no args are given)

I usually connect to the above headless installs from iPhone/iPad via [Blink Shell](https://blink.sh/) terminal, using Tailscale if I am not at home.

These dotfiles are also made to run in [workspace](https://github.com/pirafrank/workspace) Docker [image](https://hub.docker.com/r/pirafrank/workspace).

## Try it out

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/pirafrank/dotfiles?quickstart=1)

or

```sh
docker run -it pirafrank/workspace:latest
```

## Installation

First clone the repo to your `$HOME`:

```sh
cd && git clone https://github.com/pirafrank/dotfiles.git
```

Then symlink config you want to use or install them all running:

```sh
zsh install.sh all
```

You can also symlink a specific set of dotfiles by running `zsh install.sh SOME_FEATURE`. Check [the script](https://github.com/pirafrank/dotfiles/blob/main/install.sh) to know more.

### GitHub Codespaces

If no arguments are provided, `install.sh` defaults to a GitHub Codespaces installation mode, [as required by GitHub](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles). It automatically detects whether it’s running inside a Codespace. If it is not and no arguments are given, the script will quit.

### Dotbot

Alternatively, you can use [dotbot](https://github.com/anishathalye/dotbot) to manage symlinks and automate dotfiles installation. The configuration is defined in `install.conf.yaml`.

To install via Dotbot, run:

```sh
dotbot -d ~/dotfiles -c ~/dotfiles/install.conf.yaml
```

## Usage

[`GUIDE.md`](https://github.com/pirafrank/dotfiles/blob/main/GUIDE.md) serves as entrypoint of some sort of documentation. Please note that it may be incomplete or not as up-to-date as the committed configuration.

`README` files are provided in each subdir with specifics for that tool.

## Config customization

- `~/.zsh_custom` is automatically sourced if it exists. Create it to add any machine-specific non-interactive (doesn't print to sysout) entries.

- `~/.zsh_custom_pre` is automatically sourced if it exists. Create it if you need to add interactive scripts, or scripts that output to sysout. It will be loaded in `~/.zshrc` BEFORE Powerlevel10k caching. This is to enable Powerlevel10k instant prompt.

Also, `~/bin2` directory is automatically added to `$PATH`, if it exists. It is not part of the repository and it is designed to add your-own or machine-specific executables.

That's part of it, there is no real how-to actually. For more info just look at the code.

## Features

### Pager

`less` is used as pager.

[batcat](https://github.com/sharkdp/bat) in place of `cat`.

### Utilities

Little utilities are provided in different forms in the following dirs:

- `bin`, as scripts with the dir itself being added to `$PATH`;
- `zsh/autoloaded`, as zsh functions automatically loaded at shell start;
- `zsh/common/zsh_aliases`, as shell aliases.

Many of the files and scripts in the `bin` folder come from some other repos of mine and here are gathered. Although those repositories are publicly available on GitHub, I am going to only maintain them in this repo.

### Fonts

In terminal clients and IDEs, these fonts are used (ordered by preference):

- [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)
- [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip)

with fallbacks to:

```txt
'JetBrains Mono', 'Droid Sans Mono', Consolas, 'Courier New', monospace
```

[icons.txt](https://github.com/pirafrank/dotfiles/tree/main/icons.txt) is used to check terminal render of Nerd Fonts.

### Vim/Neovim

I use Neovim more than Vim. The first is configured to be a full-fledged IDE, while the latter to be an advanced text editor. Common configuration is shared for a seamless experience.

This allows me to have a slimmer experience the times I don't need to code in an environment and don't want to setup IDE-like tooling in the terminal.

Configuration details and more are available in [README](https://github.com/pirafrank/dotfiles/blob/main/vim/README.md).

### AI integration

AI integration is provided via:

- [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim) in Neovim
- [opencode](https://opencode.ai/) loading
- [Cursor](https://github.com/pirafrank/dotfiles/blob/main/cursor) config and MCP servers

## Credits

### Scripts

I wrote most of the scripts in the `bin` folder, with some of them already publicly available as [gists](https://gist.github.com/pirafrank). But others come or contain pieces from the web (twitter? google? stackoverflow?). Honestly I can't remember where I got them from, but you should find the original authors in the comments.

### Themes

Those without *pirafrank* in their name come from the web, credits go to their creators. I keep them here for the sake of simplicity. I'll try to keep this readme updated to keep them all.

- vim themes
  - [*noctu*](https://github.com/noahfrederick/vim-noctu)
  - [*dim*](https://github.com/jeffkreeftmeijer/vim-dim)
- *themerdev*-prefixed themes come from [themer.dev](https://themer.dev/).

## License

Code in this repo is given away for free, as-is and with NO WARRANTY as per the MIT license.

By the way, if something really blows your mind, I'll be happy if you get in touch with me. I always appreciated feedback!

Enjoy!
