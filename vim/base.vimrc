
"set encoding (internal representation)
set encoding=utf-8

" representation that will be used when the file is written
"set fileencoding = utf-8

" possible encodings to test when reading a file
set fileencodings=utf-8,latin-1,cp1251

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


""" tabs and indentation

"allow backspacing over (indent,eol,start) everything in insert mode
set bs=2

"always enabled autoindent
set ai

"enable smart indent
set si

" set tabstop=4 "4 space tab
" set shiftwidth=4 "The amount to block indent when using < and >
" set smarttab "Uses shiftwidth instead of tabstop at start of lines
" set expandtab "Replaces a <TAB> with spaces (more portable)
" set softtabstop=4 "Causes backspace to delete 4 spaces = converted <TAB>
set shiftwidth=2
set tabstop=8 softtabstop=0 expandtab


""" lines and cursor

"show line,column
set ruler

"show line numbers in grey color
set number "relativenumber
highlight LineNr ctermfg=grey

" highlight the current line
set cursorline

" highlight the current column
set cursorcolumn


""" paste options

" avoid tab increments while pasting content over ssh connection
" IMPORTANT : When the 'paste' option is switched on mapping in Insert mode and
"             Command-line mode is disabled. In other words remaps do NOT work.
"set paste
" instead of setting paste ON permanently, toggle it
" set pastetoggle=<leader>p
set pastetoggle=<C-y>
