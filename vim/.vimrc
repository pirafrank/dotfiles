
"set encoding
set encoding=utf-8

"Use Vim settings in place of Vi ones
set nocompatible

" case insensitive search by default
set ignorecase

" case sensitive search if pattern contains any upper case letter
" (you need to 'set ignorecase' first)
set smartcase

" set incremental search
set incsearch

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

"show line numbers in grey color
set number
highlight LineNr ctermfg=grey

"spaces for indenting
set shiftwidth=2

"use spaces instead of tabs
"set expandtab
set tabstop=8 softtabstop=0 expandtab

" wrap around in search
set wrapscan
" disable wrapscan
"set nowrapscan

" avoid tab increments while pasting content over ssh connection
" IMPORTANT : When the 'paste' option is switched on mapping in Insert mode and 
"             Command-line mode is disabled. In other words remaps do NOT work.
"set paste

" instead of setting paste ON permanently, toggle it
" set pastetoggle=<leader>p
set pastetoggle=<C-p>

" remap ESC btn
inoremap jj <Esc>

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
