#!/bin/bash

now="$(date +'%Y%m%d_%H%M%S')"

mkdir -p ~/.config/lf
if [[ -f ~/.config/lf/lfrc ]]; then
  mv ~/.config/lf/lfrc ~/.config/lf/lfrc_${now} 
fi
ln -s ~/dotfiles/lf/lfrc ~/.config/lf/lfrc

