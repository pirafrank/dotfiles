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

  " Deps
  Plug 'nvim-lua/plenary.nvim', Cond(is_nvim)         " Dependency lib
  Plug 'nvim-lua/popup.nvim', Cond(is_nvim)           " Dependency lib
  Plug 'MunifTanjim/nui.nvim', Cond(is_nvim)          " UI lib

  " UI
  Plug 'luukvbaal/stabilize.nvim', Cond(is_nvim)      " stabilize UI splits
  Plug 'stevearc/dressing.nvim', Cond(is_nvim)        " better nvim UI
  Plug 'ryanoasis/vim-devicons', Cond(is_vim)         " Nerd font viml support
  Plug 'nvim-tree/nvim-web-devicons', Cond(is_nvim)   " Nerd font lua support
  Plug 'folke/twilight.nvim', Cond(is_nvim)           " dim inactive blocks of code

  " Brackets
  Plug 'tpope/vim-surround'                   " delete/change/add surroundings
  Plug 'luochen1990/rainbow'                  " color match bracket pairs
  Plug 'cohama/lexima.vim'                    " auto-closes parenthesis
  Plug 'godlygeek/tabular'                    " automatic text alignment

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
  Plug 'junegunn/fzf.vim', Cond(is_vim)                " fzf + rg + vim integration
  Plug 'ctrlpvim/ctrlp.vim', Cond(is_vim)              " Moving around in vim
  "Plug 'mileszs/ack.vim'                               " ACK, AG, RG...
  Plug 'nvim-telescope/telescope.nvim', Cond(is_nvim)  " Moving around in nvim
  Plug 'nvim-telescope/telescope-frecency.nvim', Cond(is_nvim)

  " Right sidebar
  " { 'on': 'TagbarToggle' } fixes slow startup when tagbar is used with airline:
  "   https://github.com/vim-airline/vim-airline/issues/1313
  Plug 'preservim/tagbar', Cond(is_vim, { 'on': 'TagbarToggle' })
  Plug 'liuchengxu/vista.vim', Cond(is_nvim)

  " Terminal
  Plug 'voldikss/vim-floaterm', Cond(has_terminal)    " vim float term

  " Pasting
  Plug 'roxma/vim-paste-easy'                         " auto-set paste mode
  Plug 'ojroques/vim-oscyank'                         " copy-paste through SSH

  " More
  Plug 'editorconfig/editorconfig-vim'                " editorconfig
  Plug 'tpope/vim-commentary'                         " toggle comments
  Plug 'LintaoAmons/bookmarks.nvim', Cond(is_nvim)    " bookmarks handling
  Plug 'kkharji/sqlite.lua', Cond(is_nvim)            " sqlite3 dep for bookmarks
  Plug 'smoka7/hop.nvim', Cond(is_nvim, { 'tag': '*' })
  Plug 'stevearc/oil.nvim', Cond(is_nvim)             " edit fs like a buffer
  Plug '2kabhishek/nerdy.nvim', Cond(is_nvim)         " nerd fonts icons list

  " AI
  "Plug 'github/copilot.vim', Cond(is_nvim)            " GH Copilot (VimL)
  Plug 'zbirenbaum/copilot.lua', Cond(is_nvim)        " Copilot (Lua)
  Plug 'zbirenbaum/copilot-cmp', Cond(is_nvim)        " Copilot cmp source
  Plug 'CopilotC-Nvim/CopilotChat.nvim', Cond(is_nvim, { 'branch': 'main' })  " Copilot chat

  """""""""""""""""""""""""""""" colorschemas """"""""""""""""""""""""""""""""

  Plug 'rafi/awesome-vim-colorschemes'
  "Plug 'flazz/vim-colorschemes'
  "Plug 'flrnprz/plastic.vim'
  "Plug 'noahfrederick/vim-noctu'
  "Plug 'jeffkreeftmeijer/vim-dim'
  "Plug 'noahfrederick/vim-hemisu'
  "Plug 'sainnhe/sonokai'
  "Plug 'hzchirs/vim-material'
  "Plug 'folke/tokyonight.nvim', Cond(is_nvim, { 'branch': 'main' })
  "Plug 'ghifarit53/tokyonight-vim', Cond(is_vim)

  """""""""""""""" Language support (syntax, linting, etc.) """"""""""""""""""

  " Syntax highlighting
  Plug 'sheerun/vim-polyglot', Cond(is_vim)              " syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', Cond(is_nvim, {'do': ':TSUpdate'})  " syntax highlighting

  " Linters
  Plug 'dense-analysis/ale', Cond(is_vim)                " linting

  " LSP
  Plug 'williamboman/mason.nvim', Cond(is_nvim)          " manage LSP, DAP, linters, and formatters
  Plug 'williamboman/mason-lspconfig.nvim',Cond(is_nvim) " mason extensions with lspconfig utils
  Plug 'neovim/nvim-lspconfig', Cond(is_nvim)            " LSP configuration
  Plug 'hrsh7th/cmp-nvim-lsp', Cond(is_nvim)             " LSP support
  Plug 'hrsh7th/cmp-buffer', Cond(is_nvim)               " Buffer support
  Plug 'hrsh7th/cmp-path', Cond(is_nvim)                 " Path support
  Plug 'hrsh7th/cmp-cmdline', Cond(is_nvim)              " cmdline support
  Plug 'hrsh7th/cmp-nvim-lua', Cond(is_nvim)             " Neovim Lua API
  Plug 'onsails/lspkind-nvim', Cond(is_nvim)             " VSCode-like pictograms
  Plug 'hrsh7th/nvim-cmp', Cond(is_nvim)                 " Autocomplete
  Plug 'j-hui/fidget.nvim', Cond(is_nvim)                " show nvim-lsp progress
  Plug 'L3MON4D3/LuaSnip', Cond(is_nvim, {'tag': 'v2.*', 'do': 'make install_jsregexp'})
  Plug 'saadparwaiz1/cmp_luasnip', Cond(is_nvim)

  " Debugger
  Plug 'mfussenegger/nvim-dap', Cond(is_nvim)            " Debug Adapter Protocol client
  Plug 'rcarriga/nvim-dap-ui', Cond(is_nvim)             " Debugger UI

  " in vim, use deoplete for smart autocompletion
  " check requirements: you need to install pynvim module:
  " python3 -m pip install --user pynvim
  "if is_vim && has('python3')
  "  Plug 'Shougo/deoplete.nvim'
  "  Plug 'roxma/nvim-yarp'
  "  Plug 'roxma/vim-hug-neovim-rpc'
  "endif

  """ java """
  "filetype off
  "Plug 'ycm-core/YouCompleteMe', {'for': 'java'}
  "map <C-]> :YcmCompleter GoToImprecise<CR>
  "Plug 'artur-shaik/vim-javacomplete2', Cond(is_vim, {'for': 'java'})
  Plug 'mfussenegger/nvim-jdtls', Cond(is_nvim, {'for': 'java'})

  """ python """
  " (jedi needed! run 'pip3 install --user jedi --upgrade' before!)
  "Plug 'deoplete-plugins/deoplete-jedi', Cond(is_vim, {'for': 'py'})

  """ golang """
  " run :GoInstallBinaries after plugin install
  "Plug 'fatih/vim-go', Cond(is_vim, { 'do': ':GoUpdateBinaries', 'for': 'go' })

  """ rust """
  " note: you need to run this first to install the required components
  " rustup component add rls rust-analysis rust-src rustfmt rust-analyzer
  "Plug 'rust-lang/rust.vim', Cond(is_vim, {'for': 'rs'})
  Plug 'simrat39/rust-tools.nvim', Cond(is_nvim, {'for': 'rs'})

  """ javascript """

  """ markdown """
  Plug 'ellisonleao/glow.nvim', Cond(is_nvim)


  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#end()


" load common config
source ~/dotfiles/vim/common/base.vim
source ~/dotfiles/vim/common/backup.vim
source ~/dotfiles/vim/common/commands.vim
source ~/dotfiles/vim/common/mappings.vim
source ~/dotfiles/vim/common/languages.vim
source ~/dotfiles/vim/common/ctags.vim
source ~/dotfiles/vim/common/gui.vim

source ~/dotfiles/vim/plugins/common.vim
source ~/dotfiles/vim/plugins/colors.vim

if is_vim
  source ~/dotfiles/vim/plugins/vim_only.vim
elseif is_nvim
  lua require('treesitter')
  lua require('filetypes')
  lua require('plugins')
  lua require('lsp')
  lua require('autocomplete')
  lua require('languages')
  lua require('commands')
  lua require('mappings')
  lua require('autocmds')
endif
