" .vimrc - Francesco Pira <dev@fpira.com>

" Lazy loading
" From https://github.com/junegunn/vim-plug/wiki/faq#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

let is_vim = !has('nvim')
let is_nvim = has('nvim')
let has_terminal = has('nvim') || has('terminal')


""" plugins

" automatically install vim-plug if it's not
if has('nvim')
  let $BASE = stdpath('config')
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
  let $BASE = '$HOME/.vim'
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" using vim-plug as plugin manager
" (https://github.com/junegunn/vim-plug)
call plug#begin($BASE.'/plugged')

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


" load config
source ~/dotfiles/vim/base.vimrc
source ~/dotfiles/vim/backup.vimrc
source ~/dotfiles/vim/mappings.vimrc
source ~/dotfiles/vim/ctags.vimrc

source ~/dotfiles/vim/plugins.vimrc
source ~/dotfiles/vim/colors.vimrc
source ~/dotfiles/vim/gui.vimrc
