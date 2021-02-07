#!/bin/bash

file="$1"

if [[ -z $file ]]; then
  echo "Please add output filename as argument"
  exit 1
fi

code --list-extensions | sort | xargs -L 1 echo code --install-extension > "${file}.sh"
