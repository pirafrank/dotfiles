
""" backup settings
" settings from: https://github.com/lengthmin/dotfiles/blob/master/ubuntu_wsl/init.vim

" it works only if directories exist
" create them first with strict perms
" (you may edit sensitive content in vim)
silent !mkdir -p ~/.vim/swap && chmod 700 ~/.vim/swap
silent !mkdir -p ~/.vim/backups && chmod 700 ~/.vim/backups
silent !mkdir -p ~/.vim/undo && chmod 700 ~/.vim/undo

set swapfile
set directory^=~/.vim/swap//

" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" patch required to honor double slash at end
set backupdir^=~/.vim/backups//
" persist the undo tree for each file
set undofile
set undodir^=~/.vim/undo//

""" update time
" If this many milliseconds nothing is typed the swap file will be written to disk
" default is 4000 milliseconds
set updatetime=400
