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
