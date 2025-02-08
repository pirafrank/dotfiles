# dotfiles

My dotfiles, simple as that.

This repo is a never-ending WIP. It's not meant to be sensible for everybody, or anyone, as YMMV. But I hope it may be useful to you somehow.

## Supported platforms

My daily drivers currently are ~~alacritty~~ wezterm + zsh + tmux on:

- ~~Ubuntu 20.04 WSL 2 on Windows 10 (20H2)~~, upgraded to Ubuntu 22.04 WSL 2 on Windows 11
- ~~Ubuntu 20.04 desktop~~, upgraded to Ubuntu 22.04 desktop

These dotfiles are also used on:

- Debian ~~10~~ server accessed via mosh connection on iPad, upgraded to Debian ~~11~~ 12
- [workspace](https://github.com/pirafrank/workspace) Docker image ([link](https://hub.docker.com/r/pirafrank/workspace))
- GitHub Codespaces
- ~~occasionally macOS 10.15 (via iTerm2)~~ I gifted the MacBook to my family!

## Try it out

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/pirafrank/dotfiles?quickstart=1)

or

```sh
docker run -it pirafrank/workspace:latest
```

## Install

First clone the repo to your $HOME.

```sh
cd && git clone https://github.com/pirafrank/dotfiles.git
```

Then symlink config you want to use or install them all running `zsh install.sh all`. You can also symlink a specific set of dotfiles by running `zsh install.sh SOME_FEATURE`. Check the script content to know more.

`~/.zsh_custom` is automatically sourced if it exists. Create it to add any machine-specific non-interactive (doesn't print to sysout) entries. If you need to add interactive scripts, or scripts that output to sysout, please create `~/.zsh_custom_pre`. It will be loaded in `~/.zshrc` BEFORE Powerlevel10k caching. This is to enable Powerlevel10k instant prompt.

`~/bin2` is automatically added to `$PATH`, if it exists. It is not part of the repo. Create it to add your-own or machine-specific executables.

That's part of it, there is no real how-to actually. For more info just look at the code.

## Getting started

[`GUIDE.md`](https://github.com/pirafrank/dotfiles/blob/main/GUIDE.md) may (hopefully) help, yet it will forever be incomplete.

## Utilities

Little utilities are provided in different forms in the following dirs:

- `bin`, as scripts with the dir itself being added to `$PATH`;
- `zsh/autoloaded`, as zsh functions automatically loaded at shell start;
- `zsh/common/zsh_aliases`, as shell aliases.

Many of the files and scripts in the `bin` folder come from some other repos of mine and here are gathered. Although those repositories are publicly available on GitHub, I am going to only maintain them in this repo.

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
