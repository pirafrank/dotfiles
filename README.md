# dotfiles

[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/pirafrank.svg?style=social&label=Follow%20%40pirafrank)](https://twitter.com/pirafrank)

My dotfiles, simple as that.

This repo is a never-ending WIP. It's not meant to be sensible for everybody, or anyone, as YMMV.

## Supported platforms

My daily drivers currently are alacritty+zsh+tmux on:

- Ubuntu 20.04 WSL on Windows 10 (20H2)
- Ubuntu 20.04 desktop
- Debian 10 server accessed via mosh connection on iPad
- ~~occasionally macOS 10.15 (via iTerm2)~~ I gifted the MacBook to my family!

## Try it out

Check my [workspace](https://github.com/pirafrank/workspace) project to have a ready to code environment powered by this dotfiles.

## Install

First clone the repo to your $HOME.

```sh
cd && git clone https://github.com/pirafrank/dotfiles.git
```

Then symlink config you want to use or install them all running `zsh install.sh all`. You can also symlink a specific set of dotfiles by running `zsh install.sh SET_NAME`. Check the script content to know more.

`~/.zsh_custom` is automatically sourced if it exists. Create it to add any machine-specific non-interactive (doesn't print to sysout) entries. If you need to add interactive scripts, or scripts that output to sysout, please create `~/.zsh_custom_pre`. It will be loaded in `~/.zshrc` BEFORE Powerlevel10k caching. This is to enable Powerlevel10k instant prompt.

`~/bin2` is automatically added to `$PATH`, if it exists. It is not part of the repo. Create it to add your-own or machine-specific executables.

That's part of it, there is no real how-to actually. For more info just look at the code.

## Getting started

[`GUIDE.md`](https://github.com/pirafrank/dotfiles/blob/main/GUIDE.md) file will (hopefully) help.

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

Many of the files and scripts in the `bin` folder come from some other repos of mine and here are gathered. Although those repositories are publicly available on GitHub, I am going to only maintain them in this repo.

Code in this repo is given away for free, as-is and with NO WARRANTY as per the MIT license.

By the way, if something really blows your mind, I'll be happy if you get in touch with me. I always appreciated feedback!

Enjoy!
