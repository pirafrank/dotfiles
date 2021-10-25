
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

