
""" remappings

" remap ESC btn
inoremap jj <Esc>

" leaders usually don't last, change leader
let mapleader = "\<Space>"

" cycle through open buffers
" press F5 and then choose a buffer number
" credits: https://vim.fandom.com/wiki/Easier_buffer_switching
"nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <leader>b :buffers<CR>:buffer<Space>

" easier moving to next/prev buffer
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>

" rect / block visual selection
nnoremap <c-s> <c-v>

""" panes

" Required for operations modifying multiple buffers like rename.
set hidden

" choose where to open the new pane
set splitbelow
set splitright

"split navigations
" split vertically using pipe
nnoremap <C-w>\| <C-w>v
" split horizontally using 'h'.
nnoremap <C-w>h <C-w>s
" use ctrl+[UPPERCASE] instead of ctrl+w+[lowercase] to move between splits
nnoremap <C-J> <C-w><C-J>
nnoremap <C-K> <C-w><C-K>
nnoremap <C-L> <C-w><C-L>
nnoremap <C-H> <C-w><C-H>


""" signcolumn

" toggle number and sign columns
nnoremap <silent> <C-t> :call ToggleNumAndSignColumns()<CR>

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


""" Tagbar
nmap <F9> :TagbarToggle<CR>


""" per filetype settings

" run code by pressing Ctrl+r in normal mode
au BufRead,BufNewFile *.py nnoremap <C-r> <Esc>:w<CR>:!python %<CR>
au BufRead,BufNewFile *.rs nnoremap <C-r> <Esc>:w<CR>:!cargo run %<CR>

" for C-like languages where comments have explicit end characters,
" if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c,cpp,java set formatoptions+=ro

" fixed indentation should be OK for XML and CSS.
autocmd FileType html,xhtml,css,xml,xslt set shiftwidth=2 softtabstop=2

" explicitly set two space indentation for these files
autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" ensure normal tabs in assembly files and set to NASM syntax highlighting
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

"python settings (important to replace tabs with spaces)
"autocmd FileType py set tabstop=4 shiftwidth=4 set smarttab set expandtab set softtabstop=4
" 'cinwords' Defines keywords that start an extra indent in the next line
"autocmd FileType py setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" javascript and typescript
autocmd FileType javascript,typescript set shiftwidth=2 tabstop=2 expandtab

" rust
autocmd FileType rust set shiftwidth=4 tabstop=4 softtabstop=4 expandtab
