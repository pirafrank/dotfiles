#!/usr/bin/env bash

### init

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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
    mkdir -p ${USERCONFIG}/lazygit
    mkdir -p ${HOME}/.config/htop
    mkdir -p ${HOME}/.gnupg
    if [ -e ${HOME}/bin ] || [ -h ${HOME}/bin ]; then
        echo "WARNING: ${HOME}/bin exists. Moving to .bkp"
        mv ${HOME}/bin ${HOME}/bin.bkp
    fi
    ln -s ${SCRIPT_DIR}/bin ${HOME}/bin
    mkdir -p ${HOME}/bin2
    mkdir -p ${HOME}/Code/Workspaces
}

function bashinstall {
    if [ -e ${HOME}/.bashrc ] || [ -h ${HOME}/.bashrc ]; then
        echo "WARNING: ${HOME}/.bashrc exists. Moving to .bkp"
        mv ${HOME}/.bashrc ${HOME}/.bashrc.bkp
    fi
    ln -s ${SCRIPT_DIR}/bash/.bashrc ${HOME}/.bashrc
}

function bash_aliases_install {
    if [ -e ${HOME}/.bash_aliases ] || [ -h ${HOME}/.bash_aliases ]; then
        echo "WARNING: ${HOME}/.bash_aliases exists. Moving to .bkp"
        mv ${HOME}/.bash_aliases ${HOME}/.bash_aliases.bkp
    fi
    ln -s ${SCRIPT_DIR}/bash/.bash_aliases ${HOME}/.bash_aliases
}

function ctagsinstall {
  if [ ! -f "${HOME}/.ctags" ]; then
    ln -s "${HOME}/dotfiles/ctags/.ctags" "${HOME}/.ctags"
    [ $? -eq 0 ] && echo 'Symlink created. Install ok.'
  else
    echo "WARNING: ${HOME}/.ctags exists. Skipping."
  fi
}

function fzfinstall {
    ln -s ${SCRIPT_DIR}/fzf/.fzf.zsh  ${HOME}/.fzf.zsh
    ln -s ${SCRIPT_DIR}/fzf/.fzf.bash ${HOME}/.fzf.bash
    sed -i "s@/home/francesco@${HOME}@g" ${HOME}/.fzf.bash
    sed -i "s@/home/francesco@${HOME}@g" ${HOME}/.fzf.zsh
}

function gitinstall {
    /bin/bash ${SCRIPT_DIR}/git/git_config.sh
    ln -s ${SCRIPT_DIR}/git/.gitignore_global ${HOME}/.gitignore_global
}

function gpginstall {
    mkdir -p ${HOME}/.gnupg
    ln -s "${SCRIPT_DIR}/gnupg/$(uname -s)/gpg.conf" ${HOME}/.gnupg/gpg.conf
    ln -s "${SCRIPT_DIR}/gnupg/$(uname -s)/gpg-agent.conf" ${HOME}/.gnupg/gpg-agent.conf
}

function editorconfiginstall {
    ln -s ${SCRIPT_DIR}/home/.editorconfig ${HOME}/.editorconfig
}

function inputrcinstall {
    ln -s ${SCRIPT_DIR}/home/.inputrc ${HOME}/.inputrc
}

function htoprcinstall {
    ln -s ${SCRIPT_DIR}/htop/htoprc ${HOME}/.config/htop/htoprc
}

function lazygitinstall {
    ln -s ${SCRIPT_DIR}/lazygit/config.yml ${USERCONFIG}/lazygit/config.yml
}

function tmuxinstall {
    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    ln -s ${SCRIPT_DIR}/tmux/.tmux.conf .tmux.conf
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
    if [[ ! -z "$1" ]]; then
      ln -s ${SCRIPT_DIR}/vim/$1.vimrc ${HOME}/.vimrc
    else
      ln -s ${SCRIPT_DIR}/vim/.vimrc ${HOME}/.vimrc
    fi
    mkdir -p ${HOME}/.vim
    ln -s ${SCRIPT_DIR}/vim/.vim/colors ${HOME}/.vim/colors
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

function zpreztoinstall {
    # check for zsh
    if [[ -z $ZSH_NAME ]]; then
      echo "'zpreztoinstall' function is meant to be run by zsh shell. Quitting..."
      exit 1
    fi
    zsh "$SCRIPT_DIR/zprezto_install.sh"
}

function shellfishinstall {
    echo "downloading latest version of Secure ShellFish shell integration"
    wget https://gist.github.com/palmin/46c2d0f069d0ba6b009f9295d90e171a/raw/.shellfishrc -O ${HOME}/.shellfishrc
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
  makedirs
  # install just aliases, because .bashrc in populated with Codespaces specific stuff
  bash_aliases_install
  gitinstall
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
    makedirs)
        makedirs
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
