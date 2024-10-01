#!/bin/sh

now=$(date +%Y-%m-%d_%H%M%S)
vim-startuptime -vimpath nvim > "nvim_${now}_startup.log"
#vim-startuptime > "vim_${now}_startup.log"

