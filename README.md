# dotfiles

My dotfiles, simple as that.

This is an endless WIP and holds my work and personal setup. My daily drivers are:

- macOS + macports
- Ubuntu desktop
- Debian server accessed via mosh connection on ipad

My MacBook runs the latest 10.15, but these dotfiles should work on earlier versions, too.

While almost all files in this repo will also work on non-Debian distros, setup scripts in root are designed for the Debian-based ones. That said, the only differences shoud rely only on a few package and binary names.

On Windows, WSL may work OOTB but I have no daily driver to test it on. I don't think I will ever support zsh on Cygwin, sorry.

## Installation

```sh
cd && git clone https://github.com/pirafrank/dotfiles.git
```

Then symlink config you want to use.

If you clone to another dir, please symlink it to `~/dotfiles`.

### Full setup

*Debian-based distros only.*

A full setup involves programs installation and creation of symlinks. It is meant to setup a vanilla environment and to build the Docker workspace baseimage. The setup comes in two flavors, with and without user creation:

```sh
curl -sSL https://github.com/pirafrank/dotfiles/raw/main/setup.sh
# OR
curl -sSL https://github.com/pirafrank/dotfiles/raw/main/setup_w_user.sh
```

Run the one that best fits your needs. Remember to always check the content of scripts you're about to execute before running them!

## Usage

Setup scripts in `setups` and `workspaces` dirs are meant to be executed manually on Linux or macOS, or to build Docker Image workspaces (read below). They assume `~/dotfiles` exists.

Core setup uses zsh and zprezto. Files for oh-my-zsh config are available (yet I don't use such config anymore).

`~/.zsh_custom` is automatically sourced if it exists, and `~/bin2` is automatically added to `$PATH`. Both are not part of the repo and can be used to add your-own or machine-specific customizations and other executables.

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

### Build

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

Many of the files and scripts in the `bin` folder come from some other repos of mine. Although those repositories are publicly available on GitHub, I am going to continue to maintain them in `dotfiles`. These file will get the same license they had (GNU GPL v3).

All the rest is given away for free, as-is and with NO WARRANTY. 

By the way, if something really blows your mind, I'll be happy if you cite me.

Enjoy!
