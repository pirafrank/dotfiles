""" vim settings on iSH for iOS

""" load base vimrc file
source ~/dotfiles/vim/common/base.vim

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

  " colorschemas
 " Plug 'rafi/awesome-vim-colorschemes'
 " Plug 'flazz/vim-colorschemes'
 " Plug 'flrnprz/plastic.vim'
 " Plug 'noahfrederick/vim-noctu'
 " Plug 'jeffkreeftmeijer/vim-dim'
 " Plug 'noahfrederick/vim-hemisu'

  "status/tabline light as air

  " nerdtree with git integration
  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " the almost illegal git wrapper
"  Plug 'tpope/vim-fugitive'

  " git diff plugin
  Plug 'mhinz/vim-signify'

  " editorconfig
  Plug 'editorconfig/editorconfig-vim'

call plug#end()


""" plugin settings

  " fzf options
  " set fzf runtime path
  set rtp+=~/.fzf

  " enable deoplete at startup
  let g:deoplete#enable_at_startup = 1

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
  "silent! color plastic
  "let g:lightline = { 'colorscheme': 'plastic' }

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
  let g:EditorConfig_exclude_patterns = ['oil://.\*']
  let g:EditorConfig_exclude_patterns = ['oil-ssh://.\*']
  let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']


""" source config
source ~/dotfiles/vim/common/mappings.vim
source ~/dotfiles/vim/common/languages.vim
