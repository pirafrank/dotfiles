#!/bin/bash

file="$1"
if [[ -z $file ]]; then
  echo "Please add output filename as argument"
  exit 1
fi

cp -a ${HOME}/.vscode-server/data/Machine/settings.json "${file}"

