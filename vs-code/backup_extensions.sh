#!/bin/bash
#code --list-extensions | xargs -L 1 echo code --install-extension > vs_code_restore_extensions.sh
code --list-extensions | sort | xargs -L 1 echo code --install-extension > "$1"
