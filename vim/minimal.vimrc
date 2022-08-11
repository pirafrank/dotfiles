""" vim minimal settings, no IDE features, fewer plugins

""" load base vimrc file
source ~/dotfiles/vim/base.vimrc

""" load backup config
source ~/dotfiles/vim/backup.vimrc

""" picking a color from .vim/colors
silent! color noctu

""" just in case you want plugins in the future!

" using vim-plug as plugin manager
" (https://github.com/junegunn/vim-plug)
" automatically install vim-plug if it's not
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

  """ plugins go here

  " language pack for syntax highlighting
  Plug 'sheerun/vim-polyglot'

call plug#end()


""" mappings
source ~/dotfiles/vim/mappings.vimrc
