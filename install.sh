#!/usr/bin/env bash

### init

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# assign DOTFILES to the directory where this script is located.
# it is supposed to be the root of the dotfiles repo, which you clone in your $HOME.
DOTFILES="${SCRIPT_DIR}"

# setup user config path for current operating system
platform="$(uname -s | tr '[:upper:]' '[:lower:]')"
case $platform in
  linux)
    USERCONFIG="$HOME/.config"
    ;;
  darwin)
    USERCONFIG="$HOME/Library/Application\ Support"
    ;;
  *)
    echo "Unknown platform, cannot default user config folder for current OS. Exiting..."
    exit 2
    ;;
esac

### functions

function usage {
  echo "./$0 [all|FEATURE_NAME|custom]"
}

function makedirs {
    move_if_exists "${HOME}/bin"
    ln -s ${DOTFILES}/bin ${HOME}/bin

    mkdir -p ${HOME}/bin2
    mkdir -p ${HOME}/bin2/man
    mkdir -p ${HOME}/bin2/man/man1
    mkdir -p ${HOME}/bin2/man/man5

    mkdir -p ${HOME}/Code/contrib     # contributions
    mkdir -p ${HOME}/Code/projects    # my projects
    mkdir -p ${HOME}/Code/clones      # read-only git clones
    mkdir -p ${HOME}/Code/Templates   # read-only projects boilerplates
    mkdir -p ${HOME}/Code/Workspaces  # code-station to try new stuff
}

function bashinstall {
    move_if_exists "${HOME}/.bashrc"
    ln -s ${DOTFILES}/bash/.bashrc ${HOME}/.bashrc
}

function bash_aliases_install {
    move_if_exists "${HOME}/.bash_aliases"
    ln -s ${DOTFILES}/bash/.bash_aliases ${HOME}/.bash_aliases
}

function ctagsinstall {
    move_if_exists "${HOME}/.ctags"
    ln -s "${HOME}/dotfiles/ctags/.ctags" "${HOME}/.ctags"
}

function fzfinstall {
    move_if_exists "${HOME}/.fzf.zsh"
    move_if_exists "${HOME}/.fzf.bash"
    ln -s ${DOTFILES}/fzf/.fzf.zsh  ${HOME}/.fzf.zsh
    ln -s ${DOTFILES}/fzf/.fzf.bash ${HOME}/.fzf.bash
    sed -i "s@/home/francesco@${HOME}@g" ${HOME}/.fzf.bash
    sed -i "s@/home/francesco@${HOME}@g" ${HOME}/.fzf.zsh
}

function gitinstall {
    move_if_exists "${HOME}/.gitconfig"
    move_if_exists "${HOME}/.gitignore_global"
    /bin/bash ${DOTFILES}/git/git_config.sh
    ln -s ${DOTFILES}/git/.gitignore_global ${HOME}/.gitignore_global
}

function gpginstall {
    mkdir -p ${HOME}/.gnupg
    move_if_exists "${HOME}/.gnupg/gpg.conf"
    move_if_exists "${HOME}/.gnupg/gpg-agent.conf"
    ln -s "${DOTFILES}/gnupg/$(uname -s)/gpg.conf" ${HOME}/.gnupg/gpg.conf
    ln -s "${DOTFILES}/gnupg/$(uname -s)/gpg-agent.conf" ${HOME}/.gnupg/gpg-agent.conf
}

function editorconfiginstall {
    move_if_exists "${HOME}/.editorconfig"
    ln -s ${DOTFILES}/home/.editorconfig ${HOME}/.editorconfig
}

function inputrcinstall {
    move_if_exists "${HOME}/.inputrc"
    ln -s ${DOTFILES}/home/.inputrc ${HOME}/.inputrc
}

function htoprcinstall {
    mkdir -p "${USERCONFIG}/htop"
    move_if_exists "${USERCONFIG}/htop/htoprc"
    ln -s ${DOTFILES}/htop/htoprc ${USERCONFIG}/htop/htoprc
}

function lazygitinstall {
    mkdir -p "${USERCONFIG}/lazygit"
    ln -s ${DOTFILES}/lazygit/config.yml ${USERCONFIG}/lazygit/config.yml
}

function lfinstall {
    mkdir -p "${USERCONFIG}/lf"
    move_if_exists "${USERCONFIG}/lf/lfrc"
    move_if_exists "${USERCONFIG}/lf/icons"
    ln -s "${DOTFILES}/lf/lfrc" "${USERCONFIG}/lf/lfrc"
    ln -s "${DOTFILES}/lf/icons" "${USERCONFIG}/lf/icons"
}

function mcinstall {
    move_if_exists "${USERCONFIG}/mc"
    move_if_exists "${HOME}/.local/share/mc/skins"
    mkdir -p "${USERCONFIG}/mc"
    mkdir -p "${HOME}/.local/share/mc"
    ln -s "${DOTFILES}/mc/config" "${USERCONFIG}/mc"
    ln -s "${DOTFILES}/mc/skins" "${HOME}/.local/share/mc/skins"
}

function tmuxinstall {
    move_if_exists "${HOME}/.tmux"
    mkdir -p "${HOME}/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

    move_if_exists "${HOME}/.tmux.conf"
    ln -s "${DOTFILES}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
    #tmux start-server
    #tmux new-session -d
    #${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
    #tmux kill-server
    tmux new-session -d "sleep 1" \
      && sleep 0.1 \
      && ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
    # && tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH
    # setenv -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
}

function viminstall {
    move_if_exists "${HOME}/.vimrc"
    if [[ ! -z "$1" ]]; then
      ln -s ${DOTFILES}/vim/$1.vimrc ${HOME}/.vimrc
    else
      ln -s ${DOTFILES}/vim/.vimrc ${HOME}/.vimrc
    fi

    move_if_exists "${HOME}/.vim"
    mkdir -p ${HOME}/.vim

    ln -s ${DOTFILES}/vim/.vim/colors ${HOME}/.vim/colors
    mkdir -p ${HOME}/.vim/swap && chmod 700 ${HOME}/.vim/swap
    mkdir -p ${HOME}/.vim/backups && chmod 700 ${HOME}/.vim/backups
    mkdir -p ${HOME}/.vim/undo && chmod 700 ${HOME}/.vim/undo
}

function vimpynviminstall {
    python3 -m pip install --upgrade pynvim
}

function vimplugininstall {
    vim -E -s -u "$HOME/.vimrc" +PlugInstall +qall
}

function xplrinstall {
    move_if_exists "${USERCONFIG}/xplr"
    mkdir -p "${USERCONFIG}/xplr/plugins"

    ln -s ${DOTFILES}/xplr/init.lua ${USERCONFIG}/xplr/init.lua
    ln -s ${DOTFILES}/xplr/plugins.lua ${USERCONFIG}/xplr/plugins.lua

    if command -v lua >/dev/null ; then
      lua ${DOTFILES}/xplr/clone_plugins.lua
    else
      echo "WARNING: lua is not installed. Cannot clone xplr plugins. Install lua and run xplr/clone_plugins.lua manually."
    fi
}

function yazi_install {
    (
        cd "${DOTFILES}/yazi" || exit 1
        ./install.sh
    )
}

function zpreztoinstall {
    # check for zsh
    if [[ -z $ZSH_NAME ]]; then
      echo "'zpreztoinstall' function is meant to be run by zsh shell. Quitting..."
      exit 1
    fi
    zsh "${DOTFILES}/zsh/zprezto/zprezto_install.sh"
}

function shellfishinstall {
    move_if_exists "${HOME}/.shellfishrc"
    echo "downloading latest version of Secure ShellFish shell integration"
    wget https://gist.github.com/palmin/46c2d0f069d0ba6b009f9295d90e171a/raw/.shellfishrc -O ${HOME}/.shellfishrc
}

function move_if_exists {
    local target=$1
    local suffix=".bkp.$(date +'%Y%m%d_%H%M%S')"
    local backup_path="${target}${suffix}"

    if [ -e "$target" ]; then
        echo "$target exists. Moving to $backup_path"
        mv "$target" "$backup_path"
    fi
}

function do_codespace_symlinks {
    move_if_exists "${DOTFILES}"
    ln -s '/workspaces/.codespaces/.persistedshare/dotfiles' "${DOTFILES}"
}

function do_codespace_ohmyzsh_install {
    move_if_exists "$HOME/.zprofile"
    ln -s "${DOTFILES}/.devcontainer/zsh/oh-my-zsh/.zprofile" "$HOME/.zprofile"

    move_if_exists "$HOME/.zshenv"
    ln -s "${DOTFILES}/.devcontainer/zsh/oh-my-zsh/.zshenv" "$HOME/.zshenv"

    move_if_exists "$HOME/.zshrc"
    ln -s "${DOTFILES}/.devcontainer/zsh/oh-my-zsh/.zshrc" "$HOME/.zshrc"
}

function install_devcontainer_scripts {
    local scripts_dir="${DOTFILES}/.devcontainer/scripts"
    # execute all scripts in the scripts dir
    for script in "$scripts_dir"/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            "$script"
        fi
    done
}

### actual script

echo "
Note: This script can be run in bash (no args) or in zsh (with args).
Bash run is designed to be performed by GitHub Codespaces.
Check the code to know more.
"

# if no args are given, default to bash shell and
# fewer customizations to provide compatibility with GitHub Codespaces.
if [ $# -eq 0 ]; then
  # it may be unset in Codespaces
  USERCONFIG="$HOME/.config"
  DOTFILES="$HOME/dotfiles"
  # prepare codespace env by symlink dotfiles folder.
  # this isn't cloned in the Codespace $HOME by the Codespace creation process
  do_codespace_symlinks

  makedirs
  # install just aliases, because .bashrc is populated with Codespaces specific stuff
  bash_aliases_install
  do_codespace_ohmyzsh_install
  gitinstall
  lazygitinstall
  install_devcontainer_scripts
  exit 0;
fi

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

cd
case "$1" in
    all)
        makedirs
        bashinstall
        fzfinstall
        gitinstall
        gpginstall
        editorconfiginstall
        inputrcinstall
        htoprcinstall
        lazygitinstall
        tmuxinstall
        viminstall
        vimpynviminstall
        vimplugininstall
        zpreztoinstall
        shellfishinstall
        ctagsinstall
        lfinstall
        mcinstall
        yazi_install
        xplrinstall
        ;;
    ctags)
        ctagsinstall
        ;;
    fzf)
        fzfinstall
        ;;
    git)
        gitinstall
        ;;
    gpg)
        gpginstall
        ;;
    lazygit)
        lazygitinstall
        ;;
    lf)
        lfinstall
        ;;
    makedirs)
        makedirs
        ;;
    mc)
        mcinstall
        ;;
    tmux)
        tmuxinstall
        ;;
    vim)
        viminstall
        vimpynviminstall
        vimplugininstall
        ;;
    vim-noplugins)
        viminstall
        ;;
    vim-minimal)
        viminstall minimal
        vimplugininstall
        ;;
    xplr)
        xplrinstall
        ;;
    yazi)
        yazi_install
        ;;
    zsh)
        zpreztoinstall
        ;;
    shellfish)
        shellfishinstall
        ;;
    custom)
        echo "Open the script and place functions to exec below this line"
        exit 0
        ;;
    *)
        usage
        exit 1
esac
