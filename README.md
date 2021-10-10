# dotfiles

[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/pirafrank.svg?style=social&label=Follow%20%40pirafrank)](https://twitter.com/pirafrank)
[![build_images](https://github.com/pirafrank/dotfiles/actions/workflows/docker.yml/badge.svg)](https://github.com/pirafrank/dotfiles/actions/workflows/docker.yml)
[![docker_pulls](https://img.shields.io/docker/pulls/pirafrank/workspace.svg)](https://hub.docker.com/repository/docker/pirafrank/workspace)
[![GitHub tag](https://img.shields.io/github/tag/pirafrank/dotfiles?include_prereleases=&sort=semver&color=blue)](https://github.com/pirafrank/dotfiles/releases/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/pirafrank/dotfiles/blob/main/LICENSE.md)

My dotfiles and workspace-in-a-container project.

It holds my work and personal setup and fuels a portable environment in a Docker container. You can test it straight away:

```sh
docker run -it --name=workspace pirafrank/workspace:bundle
```

## Getting started

The repo is made of two parts: dotfiles and scripts.

Dotfiles only need to be symlinked, scripts are meant to setup specific features (Java+mvn, node.js, etc.) on a vanilla environment and used to build the workspace Docker images.

## Supported platforms

My daily drivers currently are:

- Ubuntu 20.04 WSL on Windows 10 (20H2)
- Ubuntu 20.04 desktop
- Debian 10 server accessed via mosh connection on ipad

My MacBook runs the latest 10.15.x, but these dotfiles should work on earlier versions, too. I don't use it so much but I try to keep the compatibility with macOS + macports.

While almost all files in this repo will also work on non-Debian distros, setup scripts in root are designed for the Debian-based ones. That said, the only differences shoud rely only on a few package and binary names.

## How to get it

Multiple options avaiable:

- run the containerized workspace (Docker required);
- symlink config and use workspace scripts in your existing env;
- or run the full setup script on a new env (e.g. a new VPS install).

### Option 1: Docker images

The aim is to create a disposable development environment taking advantage of Docker. Images are publicly available on [Docker Hub](https://hub.docker.com/r/pirafrank/workspace) in various flavors. They are:

- `pirafrank/workspace`: base image on which the others are based on. It contains dotfiles, various CLI utils and shell setup
- `pirafrank/workspace:bundle`: bundle of the ones below. Use `workspace_version` inside the container to know about what's bundled.

Also available:

- `pirafrank/workspace:java`: Java + `mvn`
- `pirafrank/workspace:node`: `nvm` + node.js
- `pirafrank/workspace:python3`: `pyenv` + Python 3
- `pirafrank/workspace:ruby`: `rvm` + Ruby
- `pirafrank/workspace:rust`: latest Rust version and its toolchain
- `pirafrank/workspace:go`: Golang workspace

All workspaces setups are in userspace.

### Option 2: config and scripts

First clone the repo to your $HOME.

```sh
cd && git clone https://github.com/pirafrank/dotfiles.git
```

Then symlink config you want to use.

Setup scripts in `setups` and `workspaces` dirs are meant to be executed manually on Linux or macOS, or to build Docker Image workspaces (read below). They assume `~/dotfiles` exists. If you clone to another dir, please symlink it to `~/dotfiles`.

Core setup uses zsh and zprezto. Files for oh-my-zsh config are available, but I don't use/update them anymore.

`~/.zsh_custom` is automatically sourced if it exists, and `~/bin2` is automatically added to `$PATH`. Both are not part of the repo and can be used to add your-own or machine-specific customizations and other executables.

That's all, there is no real how-to actually. For more info just look at the code.

### Option 3: full setup

*Debian-based distros only.*

A full setup involves programs installation and creation of symlinks. It is meant to setup a vanilla environment and to build the Docker workspace baseimage. The setup comes in two flavors, with and without user creation:

```sh
curl -sSL https://github.com/pirafrank/dotfiles/raw/main/setup.sh
# OR
curl -sSL https://github.com/pirafrank/dotfiles/raw/main/setup_w_user.sh
```

Run the one that best fits your needs. Remember to always check the content of scripts you're about to execute before running them!

## Build docker images

Use `./build-all.sh` to build all images.

Add to `pre_start.zsh` to exec anything at Docker image launch.

### Run an image

Use `run_workspace.sh` to do so. For example:

```sh
# to run the baseimage
./run-workspace.sh latest
# or to run the java11 one
./run-workspace.sh java11
# or to run it as a disposable container
./run-workspace.sh java11 --rm
# or to name it
./run-workspace.sh java11 '--name somename --rm'
```

## Workspace use cases

You can run the workspace-in-a-container in many occasions.

- easy and fast setup of CLI environment e.g. in a VPS
- [Blink Build](https://beta.blink.build/)
- interactive CaaS
- more...

### Usage in Blink Build

*Build* is a new service being built by the guys behind [Blink Shell](https://twitter.com/BlinkShell/), the best SSH and mosh client for iOS and iPadOS. It's currently in beta and allows you to SSH into any container publicly available without taking care of the underlying infrastructure, network or firewall. And it's fully integrated in Blink Shell. [I have started tinkering](https://twitter.com/pirafrank/status/1423633599459471361) with it and I have to say it's a great match with my *workspace* for a portable dev environment!

First setup: authenticate and turn on the VM (aka the *machine*)

```sh
build device authenticate
build status
build machine start
build machine status
build ssh-key add
build ssh-key list
```

then bring the workspace up and enter it

```sh
build up --image pirafrank/workspace:bundle bundle
build ssh bundle
```

*Build*s is currently available in the [community edition](https://community.blink.sh/).

For more information, run the commands with the `--help` flag.

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
