
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

  " language pack for syntax highlighting
  Plug 'sheerun/vim-polyglot'

  " ale
  Plug 'dense-analysis/ale'

  " use deoplete for smart autocompletion
  " check requirements: you need to install neovim/pynvim module: pip install neovim
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  endif
  if has('python3')
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " java
  Plug 'artur-shaik/vim-javacomplete2', {'for': 'java'}
  "filetype off
  "Plug 'ycm-core/YouCompleteMe', {'for': 'java'}
  "map <C-]> :YcmCompleter GoToImprecise<CR>

  " python
  " (jedi needed! run 'pip3 install --user jedi --upgrade' before!)
  Plug 'deoplete-plugins/deoplete-jedi', {'for': 'py'}

  " golang
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
  " run :GoInstallBinaries after plugin install

  " fuzzy everything search
  " download the plugin from github to .fzf and
  " make sure to have the latest version of the fzf binary
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " colorschemas
  Plug 'rafi/awesome-vim-colorschemes'
  Plug 'flazz/vim-colorschemes'
  Plug 'flrnprz/plastic.vim'
  Plug 'noahfrederick/vim-noctu'
  Plug 'jeffkreeftmeijer/vim-dim'
  Plug 'noahfrederick/vim-hemisu'
  Plug 'sainnhe/sonokai'
  Plug 'hzchirs/vim-material'

  "status/tabline light as air
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " nerdtree with git integration
  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " the almost illegal git wrapper
  Plug 'tpope/vim-fugitive'

  " git diff plugin
  Plug 'mhinz/vim-signify'

  " editorconfig
  Plug 'editorconfig/editorconfig-vim'

  " toggle comments
  Plug 'tpope/vim-commentary'

  " Most Recently Used (MRU) Vim Plugin
  Plug 'yegappan/mru'

call plug#end()


""" plugin settings

  " fzf options
  " set fzf runtime path
  set rtp+=~/.fzf
  " call it via CTRL+P
  nnoremap <silent> <C-p> :FZF<CR>
  inoremap <silent> <C-p> :FZF<CR>
  cnoreabbrev bb Buffers
  let g:fzf_buffers_jump = 1 " [Buffers] Jump to the existing window if possible

  " ale config
  " shorter error/warning flags
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  " custom icons for errors and warnings
  let g:ale_sign_error = '✘✘'
  let g:ale_sign_warning = '⚠⚠'
  " disable loclist at the bottom of vim
  let g:ale_open_list = 0
  let g:ale_loclist = 0
	" Setup compilers for languages
	let g:ale_linters = {
				\  'python': ['pylint'],
				\  'java': ['javac'],
        \  'go': ['gopls'],
				\ }

  " enable omnicompletion (disabled by default)
  filetype plugin indent on
  set omnifunc=syntaxcomplete#Complete

  " deoplete config
  " enable deoplete at startup
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_completion_start_length = 2
  " javacomplete config
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType java JCEnable " enable by default for .java files

  " golang autocomplete on . keypress
  au filetype go inoremap <buffer> . .<C-x><C-o>
  let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
  let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor

  " show hidden files in nerdtree by default
  let NERDTreeShowHidden=1
  " use ctrl+n to toggle nerdtree
  map <C-n> :NERDTreeToggle<CR>

  let g:NERDTreeGitStatusUseNerdFonts = 1

  " set colorscheme
  "color molokai
  "color dracula
  silent! color onedark

  " settings to use vim-plastic colorscheme
  " (live in plastic, it's fantastic)
  "set background=dark
  "color plastic
  "let g:lightline = { 'colorscheme': 'plastic' }

  " sonokai vim colorscheme
  " The configuration options should be placed before `colorscheme sonokai`.
  "let g:sonokai_style = 'andromeda'
  "let g:sonokai_enable_italic = 0
  "let g:sonokai_disable_italic_comment = 1
  "color sonokai

  " vim-material colorscheme
  "let g:material_style='oceanic'
  "set background=dark
  "colorscheme vim-material

  " 4-bit colorschemes to get consistency in 16-color terminals
  " set one of these and customize your terminal theme instead.
  "color noctu
  "color dim

  " further theme customization
  " you can use default theme and customize terminal colors instead
  "color default
  " keep line numbers grey
  highlight LineNr ctermfg=grey

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

" settings for GUI nvim
if has('gui_running' && 'nvim')

  " 4-bit colorschemes and settings
  "set background=light
  set background=dark
  colorscheme hemisu

endif

