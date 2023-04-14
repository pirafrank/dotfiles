
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
