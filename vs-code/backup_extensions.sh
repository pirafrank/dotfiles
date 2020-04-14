#!/bin/bash

file="$1"

if [[ -z $file ]]; then
  echo "Please add output filename as argument"
  exit 1
fi

#code --list-extensions | xargs -L 1 echo code --install-extension > vs_code_restore_extensions.sh
code --list-extensions | sort | xargs -L 1 echo code --install-extension > "$file"

