#!/usr/bin/env zsh

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

export ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"

# setup user defined themes for zprezto
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/zprezto/zsh_user_themes "${ZDOTDIR:-$HOME}/.zsh_user_themes"

# powerlevel10k, installation is done automatically by ~/.zpreztorc
ln -s "${ZDOTDIR:-$HOME}"/dotfiles/zsh/common/p10k.zsh "${ZDOTDIR:-$HOME}/.p10k.zsh"

# custom functions to load before powerlevel10k
echo """
# The content of this file will be read at the top of ~/.zshrc.
# Put in this file anything you need to load BEFORE Powerlevel10k instant prompt.
""" > "${$HOME}/.zsh_custom_pre"

# custom function lo load as part of .zshrc
touch ${HOME}/.zsh_custom
