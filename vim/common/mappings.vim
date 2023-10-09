
""" mappings and remappings for anything but plugins """

" remap ESC btn
inoremap jj <Esc>

" leaders won't last, change leader
let mapleader = "\<Space>"

" enable folding with the spacebar
nnoremap <leader>z za

" buffer list
" press F5 and then choose a buffer number
" credits: https://vim.fandom.com/wiki/Easier_buffer_switching
nnoremap <silent> <leader>b :buffers<CR>:buffer<Space>

" cycle through open buffers
nnoremap <F3> :bn<CR>

" rect / block visual selection
" xnoremap: visual mode only map, you need to enter visual mode first
xnoremap <c-r> <c-v>

"split navigations
" split vertically using pipe
nnoremap <leader>w <C-w>v
" split horizontally using 'h'.
nnoremap <leader>s <C-w>s
" use ctrl+[UPPERCASE] instead of ctrl+w+[lowercase] to move between splits
nnoremap <C-J> <C-w><C-J>
nnoremap <C-K> <C-w><C-K>
nnoremap <C-L> <C-w><C-L>
nnoremap <C-H> <C-w><C-H>


""" signcolumn

" toggle number and sign columns
nnoremap <silent> <leader>l :call ToggleNumAndSignColumns()<CR>

" toggle function. Works on vim>=8.1 or NeoVim
" credits: https://stackoverflow.com/posts/53930943/revisions
function! ToggleNumAndSignColumns()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        set nonumber
        let b:signcolumn_on=0
    else
        set signcolumn=yes
        set number
        let b:signcolumn_on=1
    endif
endfunction


""" paste options
" avoid tab increments while pasting content over ssh connection
" IMPORTANT : When the 'paste' option is switched on mapping in Insert mode and
"             Command-line mode is disabled. In other words remaps do NOT work.
"set paste
" instead of setting paste ON permanently, toggle it
set pastetoggle=<leader>y
