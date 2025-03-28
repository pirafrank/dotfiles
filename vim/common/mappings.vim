
""" mappings and remappings for anything but plugins """

" remap ESC btn
inoremap jj <Esc>

" leaders won't last, change leader
let mapleader = "\<Space>"

" enable folding with the spacebar
nnoremap <leader>z za

" turn off search highlighting
nnoremap <leader>n :noh<CR>

" buffer list
" press leader+b and then choose a buffer number
" credits: https://vim.fandom.com/wiki/Easier_buffer_switching
nnoremap <leader>b :buffers<CR>:buffer<Space>

" easier moving to next/prev buffer
nnoremap <leader>> :bn<CR>
nnoremap <leader>< :bp<CR>

" rect / block visual selection
" xnoremap: visual mode only map, you need to enter visual mode first
xnoremap <c-s> <c-v>

" move among split windows
nnoremap <leader>w <C-w><C-w>

" split vertically
nnoremap <leader>sv <C-w>v
" split horizontally
nnoremap <leader>sh <C-w>s

" split navigation
" use ctrl+[UPPERCASE] instead of ctrl+w+[lowercase] to move between splits
nnoremap <C-A-j> <C-w><C-J>
nnoremap <C-A-k> <C-w><C-K>
nnoremap <C-A-l> <C-w><C-L>
nnoremap <C-A-h> <C-w><C-H>

" toggle between absolute and relative numbers
nnoremap <silent> <leader>1 :ToggleLineNumbers<CR>

""" signcolumn

" toggle number and sign columns
nnoremap <silent> <leader>tl :ToggleNumAndSignColumns<CR>

""" paste options
" avoid tab increments while pasting content over ssh connection
" IMPORTANT : When the 'paste' option is switched on mapping in Insert mode and
"             Command-line mode is disabled. In other words remaps do NOT work.
"set paste
" instead of setting paste ON permanently, toggle it
nnoremap <leader>y :set paste!<CR>

