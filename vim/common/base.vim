
" set encoding (internal representation)
set encoding=utf-8

" set UI language
language en_US.utf8

" representation that will be used when the file is written
"set fileencoding = utf-8

" possible encodings to test when reading a file
set fileencodings=utf-8,latin-1,cp1251

"Use Vim settings in place of Vi ones
set nocompatible

" choose shell
if has('win32')
    set shell=pwsh.exe
endif

" autoload file changes
" undo loading by pressing 'u'
set autoread

" search deep in subdirs
set path+=**

" command line completion that makes sense
set wildmode=longest:full
set wildmenu

" always show the sidebar used by signify
set signcolumn=yes

" default updatetime 4000ms is not good for async update
set updatetime=100

" locks this number of lines while scrolling
set scrolloff=4


""" use system clipboard

" use '*' register for clipboard ops (one way).
" select in Visual mode and press 'y' to copy to primary clipboard.
" in Normal mode, press 'p' (or other paste options) to paste from the primary clipboard.
set clipboard=unnamed

" use both '*' and '+' registers for clipboard ops (two way).
" select in Visual mode and press 'y' to copy to system clipboard.
" in Normal mode, press 'p' (or other paste options) to paste from the system clipboard.
"set clipboard=unnamedplus


""" terminal

" smoother scrolling and screen redrawing
set ttyfast


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

" start searching before pressing enter
if has('reltime')
    set incsearch
endif

""" syntax

"syntax mode on
syntax on


""" tabs and indentation

"allow backspacing over (indent,eol,start) everything in insert mode
set bs=2

"always enabled autoindent
set ai

"enable smartindent
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


""" panes

" Required for operations modifying multiple buffers like rename.
set hidden

" choose where to open the new pane
set splitbelow
set splitright


""" autocomplete

" Shows the longest autcomplete.
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
set completeopt=longest,menuone,preview

