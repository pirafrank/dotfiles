
"set encoding
set encoding=utf-8

"Use Vim settings in place of Vi ones
set nocompatible

" use system clipboard
set clipboard=unnamed

" command line completion that makes sense
set wildmode=longest:full
set wildmenu

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
set number relativenumber
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


""" plugins

" using vim-plug as plugin manager
" (https://github.com/junegunn/vim-plug)
" automatically install vim-plug if it's not
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" plugins to use only with nvim
if has('nvim')

  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

  " fuzzy everything search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
  Plug 'junegunn/fzf.vim'

  " use deoplete for smart autocompletion
  " check requirements: you need to install neovim/pynvim module: pip install neovim
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " colorschemas
  Plug 'rafi/awesome-vim-colorschemes'
  Plug 'flazz/vim-colorschemes'
  Plug 'flrnprz/plastic.vim'
  Plug 'noahfrederick/vim-noctu'
  Plug 'jeffkreeftmeijer/vim-dim'

  "status/tabline light as air
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  "
  " nerdtree with git integration
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " the almost illegal git wrapper
  Plug 'tpope/vim-fugitive'

  " git diff plugin
  Plug 'mhinz/vim-signify'

  " editorconfig
  Plug 'editorconfig/editorconfig-vim'

else
  " don't use plugins with vim

endif
call plug#end()

" specific settings for nvim
if has('nvim')

  " fzf options
  " set fzf runtime path
  set rtp+=~/.fzf

  " enable deoplete at startup
  let g:deoplete#enable_at_startup = 1

  " show hidden files in nerdtree by default
  let NERDTreeShowHidden=1
  " use ctrl+n to toggle nerdtree
  map <C-n> :NERDTreeToggle<CR>

  " set colorscheme
  "color molokai
  "color dracula

  " settings to use vim-plastic colorscheme
  " (live in plastic, it's fantastic)
  "set background=dark
  "color plastic
  "let g:lightline = { 'colorscheme': 'plastic' }

  " 4-bit colorschemes to get consistency in 16-color terminals
  " set one of these and customize your terminal theme instead.
  "color noctu
  color dim

  "display all buffers in airline when there's only 1 tab open
  let g:airline#extensions#tabline#enabled = 1

  " vim-signify settings
  " default updatetime 4000ms is not good for async update
  set updatetime=100
  " sign settings
  let g:signify_sign_add               = '+'
  let g:signify_sign_delete            = '-'
  let g:signify_sign_delete_first_line = '‾'
  let g:signify_sign_change            = 'M'
  let g:signify_sign_changedelete      = g:signify_sign_change
  " show number of edited/deleted lines
  let g:signify_sign_show_count = 1

  " editorconfig settings
  let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
  let g:EditorConfig_exclude_patterns = ['scp://.\*']
  let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']

endif


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

