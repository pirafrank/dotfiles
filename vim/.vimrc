
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
set number relativenumber
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

" Required for operations modifying multiple buffers like rename.
set hidden


" plugins
"
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

  " (Optional) Multi-entry selection UI.
  Plug 'junegunn/fzf'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " note: check deoplete requirements. if you use pyenv, you may need to run:
  " pip install neovim

  " colorschemas
  Plug 'rafi/awesome-vim-colorschemes'

  " nerdtree with git integration
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " the almost illegal git wrapper
  Plug 'tpope/vim-fugitive'

  "status/tabline light as air
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " git diff plugin
  Plug 'airblade/vim-gitgutter'

else
" plugins to use with vim instead

  "Plug 'Shougo/deoplete.nvim'
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'

endif
call plug#end()

" specific settings for nvim
if has('nvim')
  let g:deoplete#enable_at_startup = 1

  " show hidden files in nerdtree by default
  let NERDTreeShowHidden=1
  " use ctrl+n to toggle nerdtree
  map <C-n> :NERDTreeToggle<CR>

  "display all buffers in airline when there's only 1 tab open
  let g:airline#extensions#tabline#enabled = 1

  "color molokai
  color dracula
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
