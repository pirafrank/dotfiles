# dotfiles

My dotfiles, simple as that.

This is a WIP and I'll add files from time to time. My usage scenario is same repo and settings for:

- macbook
- Ubuntu desktop
- Debian server accessed via mosh connection on ipad

Cygwin support may come later on. [Or may not](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Installation

Main setup comes in two versions, with and without user creation:

```sh
curl -sSL https://github.com/pirafrank/dotfiles/raw/main/setup.sh
# OR
curl -sSL https://github.com/pirafrank/dotfiles/raw/main/setup_w_user.sh
```

run the one that best fits your needs.

Or you can just clone the repo to your home dir and symlink all the things.

Please note that while about >95% of dotfiles will likely work on non-Debian distros, setup scripts are designed for the Debian-based ones. That said, the only differences shoud rely only on a few package and binary names.

## Usage

To get started, symlink config you want to use to files in your clone and add `./bin` dir to `$PATH`.

Setup scripts are meant to be execute manually to install and configure a PC setup or Docker Image workspaces (read below).

Core setup uses zsh and zprezto. Files for oh-my-zsh config are available (yet I don't use it that much anymore).

`~/.zsh_custom` is automatically sourced and `~/bin2` is automatically added to `$PATH`. Those are not part of the repo and can be used for custom/specific aliases and userspace software installation.

That's all, there is no real how-to actually. For more info just look at the code. Google is your friend.

## Docker Images

A command-line workspace in a container, based on this repo.

The aim is to create a disposable development environment taking advantage of Docker. Images are publicly available on [Docker Hub](https://hub.docker.com/r/pirafrank/workspace) in various flavors. They are:

- `pirafrank/workspace`: base image the others are based on. It contains dotfiles, various CLI utils and shell setup
- `pirafrank/workspace:java`: Java workspace based on OpenJDK or AdoptOpenJDK (check the Docker image tag)
- `pirafrank/workspace:node`: `nvm` and node env
- `pirafrank/workspace:python3`: `pyenv` and Python 3
- `pirafrank/workspace:ruby`: `rvm` and Ruby
- `pirafrank/workspace:rust`: latest Rust version and its toolchain
- `pirafrank/workspace:go`: Golang workspace

All workspaces setups are in userspace.

Please also check the `run_workspace.sh` script. It is a utility that makes running workspaces as simple as:

```sh
./run-workspace.sh pirafrank/workspace:java11
# or for a disposable container
./run-workspace.sh pirafrank/workspace:java11 --rm
```

## Credits

#### Scripts

I wrote most of the scripts in the `bin` folder, with some of them already publicly available as [gists](https://gist.github.com/pirafrank). But others come or contain pieces from the web (twitter? google? stackoverflow?). Honestly I can't remember where I got them from, but you should find the original authors in the comments.

#### Themes

Those without *pirafrank* in their name come from the web, credits go to their creators. I keep them here for the sake of simplicity. I'll try to keep this readme updated to keep them all.

- vim themes
  - [*noctu*](https://github.com/noahfrederick/vim-noctu)
  - [*dim*](https://github.com/jeffkreeftmeijer/vim-dim)
- *themerdev*-prefixed themes come from [themer.dev](https://themer.dev/).

## License

Many of the files and scripts in the `bin` folder come from some other repos of mine. Although those repositories are publicly available on GitHub, I am going to continue to maintain them in `dotfiles`. These file will get the same license they had (GNU GPL v3).

All the rest is given away for free, as-is and with NO WARRANTY. 

By the way, if something really blows your mind, I'll be happy if you cite me.

Enjoy!

