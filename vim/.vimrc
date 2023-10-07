" .vimrc - Francesco Pira <dev@fpira.com>

" load basic functions
source ~/dotfiles/vim/common/require.vim

" Lazy loading
" From https://github.com/junegunn/vim-plug/wiki/faq#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction


""" plugins

" automatically install vim-plug if it's not
if has('nvim')
  if empty(stdpath('config').'/autoload/plug.vim')
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" using vim-plug as plugin manager
" (https://github.com/junegunn/vim-plug)
" partially inspired by https://github.com/threkk/dotfiles/blob/master/dotfiles/config/nvim/init.vim
call plug#begin($BASE.'/plugged')

  """"""""""""""""""""""""""""""" Editor """""""""""""""""""""""""""""""""""""

  Plug 'nvim-lua/plenary.nvim', Cond(is_nvim)         " Dependency lib
  Plug 'nvim-lua/popup.nvim', Cond(is_nvim)           " Dependency lib

  Plug 'luukvbaal/stabilize.nvim', Cond(is_nvim)      " stabilize UI splits
  Plug 'ryanoasis/vim-devicons', Cond(is_vim)         " Nerd font viml support
  Plug 'kyazdani42/nvim-web-devicons', Cond(is_nvim)  " Nerd font lua support
  Plug 'roxma/vim-paste-easy'                         " auto-set paste mode
  Plug 'ojroques/vim-oscyank'                         " copy-paste through SSH
  Plug 'editorconfig/editorconfig-vim'                " editorconfig
  Plug 'tpope/vim-commentary'                         " toggle comments

  " Brackets
  Plug 'tpope/vim-surround'                   " delete/change/add surroundings
  Plug 'luochen1990/rainbow'                  " color match bracket pairs
  Plug 'cohama/lexima.vim'                    " auto-closes parenthesis

  " File tree
  Plug 'preservim/nerdtree', Cond(is_vim, { 'on': 'NERDTreeToggle' })
  Plug 'Xuyuanp/nerdtree-git-plugin', Cond(is_vim)
  Plug 'nvim-neo-tree/neo-tree.nvim', Cond(is_nvim)

  " Bufferline
  " in vim bufferline is provided by airline

  " Status bar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Git
  Plug 'tpope/vim-fugitive'                   " the almost illegal git wrapper
  Plug 'mhinz/vim-signify', Cond(is_vim)               " git diff in vim
  Plug 'lewis6991/gitsigns.nvim', Cond(is_nvim)        " git diff in nvim

  " Search
  " download from github to .fzf + updates binary to latest version
  Plug 'junegunn/fzf', Cond(is_vim, { 'dir': '~/.fzf', 'do': { -> fzf#install() } })
  Plug 'junegunn/fzf.vim', Cond(is_vim)                " fzf + vim integration
  Plug 'ctrlpvim/ctrlp.vim', Cond(is_vim && has_gui)   " Moving around in vim
  "Plug 'mileszs/ack.vim'                               " ACK, AG, RG...
  Plug 'nvim-telescope/telescope.nvim', Cond(is_nvim)  " Moving around in nvim

  " Right sidebar
  " { 'on': 'TagbarToggle' } fixes slow startup when tagbar is used with airline:
  "   https://github.com/vim-airline/vim-airline/issues/1313
  Plug 'preservim/tagbar', Cond(is_vim, { 'on': 'TagbarToggle' })

  " Terminal
  Plug 'voldikss/vim-floaterm', Cond(is_vim && has_terminal) " vim float term

  """""""""""""""""""""""""""""" colorschemas """"""""""""""""""""""""""""""""

  Plug 'rafi/awesome-vim-colorschemes'
  "Plug 'flazz/vim-colorschemes'
  "Plug 'flrnprz/plastic.vim'
  "Plug 'noahfrederick/vim-noctu'
  "Plug 'jeffkreeftmeijer/vim-dim'
  "Plug 'noahfrederick/vim-hemisu'
  "Plug 'sainnhe/sonokai'
  "Plug 'hzchirs/vim-material'
  Plug 'folke/tokyonight.nvim', Cond(is_nvim, { 'branch': 'main' })
  Plug 'ghifarit53/tokyonight-vim', Cond(is_vim)

  """""""""""""""" Language support (syntax, linting, etc.) """"""""""""""""""

  Plug 'sheerun/vim-polyglot', Cond(is_vim)              " syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', Cond(is_nvim)  " syntax highlighting

  Plug 'dense-analysis/ale', Cond(is_vim)                " linting

  " Autocomplete & LSP support
  Plug 'neovim/nvim-lspconfig', Cond(is_nvim)            " LSP configuration
  Plug 'hrsh7th/cmp-nvim-lsp', Cond(is_nvim)             " LSP support
  Plug 'hrsh7th/cmp-buffer', Cond(is_nvim)               " Buffer support
  Plug 'hrsh7th/cmp-path', Cond(is_nvim)                 " Path support
  Plug 'hrsh7th/cmp-cmdline', Cond(is_nvim)              " cmdline support
  Plug 'hrsh7th/cmp-nvim-lua', Cond(is_nvim)             " Neovim Lua API
  Plug 'onsails/lspkind-nvim', Cond(is_nvim)             " VSCode-like pictograms
  Plug 'hrsh7th/nvim-cmp', Cond(is_nvim)                 " Autocomplete
  Plug 'j-hui/fidget.nvim', Cond(is_nvim)                " show nvim-lsp progress

  " in vim, use deoplete for smart autocompletion
  " check requirements: you need to install pynvim module:
  " python3 -m pip install --user pynvim
  if is_vim && has('python3')
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " java
  Plug 'artur-shaik/vim-javacomplete2', Cond(is_vim, {'for': 'java'})
  "filetype off
  "Plug 'ycm-core/YouCompleteMe', {'for': 'java'}
  "map <C-]> :YcmCompleter GoToImprecise<CR>

  " python
  " (jedi needed! run 'pip3 install --user jedi --upgrade' before!)
  Plug 'deoplete-plugins/deoplete-jedi', Cond(is_vim, {'for': 'py'})

  " golang
  Plug 'fatih/vim-go', Cond(is_vim, { 'do': ':GoUpdateBinaries', 'for': 'go' })
  " run :GoInstallBinaries after plugin install

  " rust
  Plug 'rust-lang/rust.vim', Cond(is_vim, {'for': 'rs'})
  " note: you need to run this first to install the required components
  " rustup component add rls rust-analysis rust-src rustfmt rust-analyzer

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#end()


" load common config
source ~/dotfiles/vim/common/base.vim
source ~/dotfiles/vim/common/backup.vim
source ~/dotfiles/vim/common/mappings.vim
source ~/dotfiles/vim/common/languages.vim
source ~/dotfiles/vim/common/ctags.vim
source ~/dotfiles/vim/common/gui.vim

source ~/dotfiles/vim/plugins/common.vim
source ~/dotfiles/vim/plugins/colors.vim

if is_vim
  source ~/dotfiles/vim/plugins/vim_only.vim
elseif is_nvim
  lua require('plugins')
  lua require('languages')
  lua require('autocmds')
  lua require('utils')
endif
