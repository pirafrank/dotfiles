
"set encoding
set encoding=utf-8

"Use Vim settings in place of Vi ones
set nocompatible

" search deep in subdirs
set path+=**

" use system clipboard
set clipboard=unnamed

" command line completion that makes sense
set wildmode=longest:full
set wildmenu

" always show the sidebar used by signify
set signcolumn=yes

""" search

" case insensitive search by default
set ignorecase

" case sensitive search if pattern contains any upper case letter
" (you need to 'set ignorecase' first)
set smartcase

" set incremental search
set incsearch

"highlight all search patterns
set hlsearch

" wrap around in search
set wrapscan
" disable wrapscan
"set nowrapscan


""" syntax

"syntax mode on
syntax on

"allow backspacing over (indent,eol,start) everything in insert mode
set bs=2

"always enabled autoindent
set ai

"enable smart indent
set si

"show line,column
set ruler

"show line numbers in grey color
set number "relativenumber
highlight LineNr ctermfg=grey

"spaces for indenting
set shiftwidth=2

"use spaces instead of tabs
"set expandtab
set tabstop=8 softtabstop=0 expandtab


""" paste options

" avoid tab increments while pasting content over ssh connection
" IMPORTANT : When the 'paste' option is switched on mapping in Insert mode and
"             Command-line mode is disabled. In other words remaps do NOT work.
"set paste
" instead of setting paste ON permanently, toggle it
" set pastetoggle=<leader>p
set pastetoggle=<C-y>


""" remappings

" remap ESC btn
inoremap jj <Esc>


""" panes

" Required for operations modifying multiple buffers like rename.
set hidden

" choose where to open the new pane
set splitbelow
set splitright

"split navigations
" use ctrl+[UPPERCASE] instead of ctrl+w+[lowercase]
nnoremap <C-J> <C-w><C-J>
nnoremap <C-K> <C-w><C-K>
nnoremap <C-L> <C-w><C-L>
nnoremap <C-H> <C-w><C-H>
