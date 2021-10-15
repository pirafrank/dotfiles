#!/bin/bash

### init

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
    ln -s ${HOME}/dotfiles/bin ${HOME}/bin
    mkdir -p ${HOME}/bin2
    mkdir -p ${HOME}/Code/Workspaces
}

function bashinstall {
    ln -s ${HOME}/dotfiles/bash/.bashrc ${HOME}/.bashrc
}

function fzfinstall {
    ln -s ${HOME}/dotfiles/fzf/.fzf.zsh  ${HOME}/.fzf.zsh
    ln -s ${HOME}/dotfiles/fzf/.fzf.bash ${HOME}/.fzf.bash
    sed -i "s@/home/francesco@${HOME}@g" ${HOME}/.fzf.bash
    sed -i "s@/home/francesco@${HOME}@g" ${HOME}/.fzf.zsh
}

function gitinstall {
    /bin/bash ${HOME}/dotfiles/git/git_config.sh
    ln -s ${HOME}/dotfiles/git/.gitignore_global ${HOME}/.gitignore_global
}

function gpginstall {
    mkdir -p ${HOME}/.gnupg
    ln -s "${HOME}/dotfiles/gnupg/$(uname -s)/gpg.conf" ${HOME}/.gnupg/gpg.conf
    ln -s "${HOME}/dotfiles/gnupg/$(uname -s)/gpg-agent.conf" ${HOME}/.gnupg/gpg-agent.conf
}

function editorconfiginstall {
    ln -s ${HOME}/dotfiles/home/.editorconfig ${HOME}/.editorconfig
}

function inputrcinstall {
    ln -s ${HOME}/dotfiles/home/.inputrc ${HOME}/.inputrc
}

function htoprcinstall {
    ln -s ${HOME}/dotfiles/htop/htoprc ${HOME}/.config/htop/htoprc
}

function lazygitinstall {
    ln -s ${HOME}/dotfiles/lazygit/config.yml ${USERCONFIG}/lazygit/config.yml
}

function tmuxinstall {
    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    ln -s ${HOME}/dotfiles/tmux/.tmux.conf .tmux.conf
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
    ln -s ${HOME}/dotfiles/vim/.vimrc ${HOME}/.vimrc
    mkdir -p ${HOME}/.vim
    ln -s ${HOME}/dotfiles/vim/.vim/colors ${HOME}/.vim/colors
}

function vimplugininstall {
    python3 -m pip install --upgrade pynvim
    vim -E -s -u "$HOME/.vimrc" +PlugInstall +qall
}

function zpreztoinstall {
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/zsh_aliases "${ZDOTDIR:-$HOME}/.zsh_aliases"
    ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/zsh_env "${ZDOTDIR:-$HOME}/.zsh_env"

    export ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"

    # setup user defined themes for zprezto
    ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/zsh_user_themes "${ZDOTDIR:-$HOME}/.zsh_user_themes"

    # powerlevel10k, installation is done automatically by ~/.zpreztorc
    ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/p10k.zsh "${ZDOTDIR:-$HOME}/.p10k.zsh"
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
  bashinstall
  gitinstall
  gpginstall
  editorconfiginstall
  inputrcinstall
  htoprcinstall
  viminstall
  shellfishinstall
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
        zpreztoinstall
        shellfishinstall
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
    tmux)
        tmuxinstall
        ;;
    vim)
        viminstall
        vimplugininstall
        ;;
    vim-noplugins)
        viminstall
        ;;
    zsh)
        zpreztoinstall
        ;;
    shellfish)
        shellfishinstall
        ;;
    custom)
        echo "Open the script and place function to exec below this line"
        exit 0
        ;;
    *)
        usage
        exit 1
esac
