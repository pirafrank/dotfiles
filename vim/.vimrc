
""" load base vimrc file
source ~/dotfiles/vim/base.vimrc

""" load backup config
source ~/dotfiles/vim/backup.vimrc

""" load ctags configuration
source ~/dotfiles/vim/ctags.vimrc

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
  " check requirements: you need to install pynvim module:
  " python3 -m pip install --user pynvim
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

  " rust
  Plug 'rust-lang/rust.vim', {'for': 'rs'}
  " note: you need to run this first to install the required components
  " rustup component add rls rust-analysis rust-src rustfmt rust-analyzer

  " fuzzy everything search
  " download the plugin from github to .fzf and
  " make sure to have the latest version of the fzf binary
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " colorschemas
  Plug 'rafi/awesome-vim-colorschemes'
  "Plug 'flazz/vim-colorschemes'
  "Plug 'flrnprz/plastic.vim'
  "Plug 'noahfrederick/vim-noctu'
  "Plug 'jeffkreeftmeijer/vim-dim'
  "Plug 'noahfrederick/vim-hemisu'
  "Plug 'sainnhe/sonokai'
  "Plug 'hzchirs/vim-material'

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

  " fzf + rg + vim integration
  Plug 'wookayin/fzf-ripgrep.vim'

  " Tagbar
  " { 'on': 'TagbarToggle' } fixes slow startup when tagbar is used with airline:
  "   https://github.com/vim-airline/vim-airline/issues/1313
  " disabling airline integration with tagbar may help too, set it to 0 to disable.
  "let g:airline#extensions#tagbar#enabled = 0
  Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }

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
        \  'rust': ['rls', 'cargo'],
				\ }

  let g:ale_rust_rls_toolchain = ''
  let g:ale_rust_rls_executable = 'rust-analyzer'

  " do not enable rustfmt, or :w will become painfully slow
  " issue: https://github.com/rust-lang/rust.vim/issues/293
  " let b:ale_fixers = { 'rust': ['rustfmt'] }

  " same as above, due to rustfmt.
  " format manually by running :RustFmt
  " set g:rustfmt_autosave = 1, to format on save in rust files
  let g:rustfmt_autosave = 0

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


""" colorscheme settings

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


""" mappings
source ~/dotfiles/vim/mappings.vimrc


"apply these settings only with GUIs, like MacVim
if has("gui_running")

  "set highlightning colors
  colorscheme flatland

  "set window width
  set columns=140

  "set window height
  set lines=48

  "enable use of mouse
  set mouse=a

  "set font for gVim on Windows
  if has("gui_win32")
    "set guifont=MesloLGS\ Nerd\ Font\ Mono:h10
    set guifont=JetBrains\ Mono:h10
  endif

endif

" settings for GUI nvim
if has('gui_running' && 'nvim')

  " 4-bit colorschemes and settings
  "set background=light
  set background=dark
  colorscheme hemisu

endif

