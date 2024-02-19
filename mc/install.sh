#!/bin/bash

mkdir -p ${HOME}/.config
mkdir -p ${HOME}/.local/share

if [[ -e ${HOME}/.config/mc ]]; then
    mv ${HOME}/.config/mc ${HOME}/.config/mc.bkp
fi

if [[ -e ${HOME}/.local/share/mc/skins ]]; then
    mv ${HOME}/.local/share/mc/skins ${HOME}/.local/share/mc/skins.bkp
fi

ln -s ${HOME}/dotfiles/mc/config ${HOME}/.config/mc
ln -s ${HOME}/dotfiles/mc/skins ${HOME}/.local/share/mc/skins

#sed -i 's|\(^skin=\).*$|\1onedark|' ${HOME}/.config/mc/ini

