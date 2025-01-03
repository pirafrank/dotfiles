
""" backup settings
" settings from: https://github.com/lengthmin/dotfiles/blob/master/ubuntu_wsl/init.vim

" it works only if directories exist
" create them first with strict perms
" (you may edit sensitive content in vim)
"silent !mkdir -p ~/.vim/swap && chmod 700 ~/.vim/swap
"silent !mkdir -p ~/.vim/backups && chmod 700 ~/.vim/backups
"silent !mkdir -p ~/.vim/undo && chmod 700 ~/.vim/undo

set swapfile

" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" persist the undo tree for each file
set undofile

if has('nvim')
" this is neovim
  if has('win32') || has('win64')
    set directory^=$USERPROFILE/AppData/Local/nvim/swap//
    set backupdir^=$USERPROFILE/AppData/Local/nvim/backups//
    set undodir^=$USERPROFILE/AppData/Local/nvim/undo//
  else
    set directory^=~/.local/share/nvim/swap//
    set backupdir^=~/.local/share/nvim/backups//
    set undodir^=~/.local/share/nvim/undo//
  endif
else
" this is vim
  if has('win32') || has('win64')
    set directory^=$USERPROFILE/vimfiles/swap//
    set backupdir^=$USERPROFILE/vimfiles/backups//
    set undodir^=$USERPROFILE/vimfiles/undo//
  else
    set directory^=~/.vim/swap//
    " patch required to honor double slash at end
    set backupdir^=~/.vim/backups//
    set undodir^=~/.vim/undo//
  endif
endif

""" update time
" If this many milliseconds nothing is typed the swap file will be written to disk
" default is 4000 milliseconds
set updatetime=400

