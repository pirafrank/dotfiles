#!/bin/bash

now="$(date +'%Y%m%d_%H%M%S')"

mkdir -p ~/.config/lf

if [[ -f ~/.config/lf/lfrc ]]; then
  mv ~/.config/lf/lfrc ~/.config/lf/lfrc_${now} 
fi

if [[ -e ~/.config/lf/icons ]]; then
  mv ~/.config/lf/icons ~/.config/lf/icons_${now}
fi

ln -s ~/dotfiles/lf/lfrc ~/.config/lf/lfrc
ln -s ~/dotfiles/lf/icons ~/.config/lf/icons

