
"Use Vim settings in place of Vi ones
set nocompatible

"syntax mode on
syntax on

"highlight all search patterns
set hlsearch

"allow backspacing over (indent,eol,start) everything in insert mode
set bs=2

"always enabled autoindent
set ai

"enable smart indent
set si

"show line,column
set ruler

"spaces for indenting
set shiftwidth=2

"use spaces instead of tabs
set expandtab

" wrap around in search
set wrapscan

" avoid tab increments while pasting content over ssh connection
set paste

" map jj to ESC
imap ;; <Esc>

"apply these settings only with GUIs, like MacVim
if has("gui_running")

  "set highlightning colors
  colorscheme flatland

  "set window width
  set columns=108

  "set window height
  set lines=52

" enable use of mouse
  set mouse=a

endif
