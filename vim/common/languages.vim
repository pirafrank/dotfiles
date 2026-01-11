
""" per filetype settings

" for C-like languages where comments have explicit end characters,
" if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c,cpp set formatoptions+=ro

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

" Shell scripts
autocmd FileType sh set textwidth=0

" Dockerfiles
autocmd BufRead,BufNewFile *.dockerfile setfiletype dockerfile

" java
augroup javaconf
  au!
  autocmd FileType java set tabstop=4
  autocmd FileType java set shiftwidth=4
  autocmd FileType java set smarttab
  autocmd FileType java set expandtab
  autocmd FileType java set softtabstop=4
  autocmd FileType java set wrap
  " Folding is handled by treesitter in nvim
  " autocmd FileType java set foldmethod=indent
  " autocmd FileType java set foldlevel=99
  " autocmd FileType java set foldenable
  autocmd FileType java set encoding=utf-8
  " auto-close HTML tags
  autocmd FileType java set matchpairs+=<:>
  " Show matching parentheses/brackets
  autocmd FileType java set showmatch
  " if starting a new line in the middle of a comment automatically
  " insert the comment leader characters:
  autocmd FileType java set formatoptions+=ro
augroup END

" python
augroup pyconf
  au!
  "python settings (important to replace tabs with spaces)
  autocmd FileType python set tabstop=4
  autocmd FileType python set shiftwidth=4
  autocmd FileType python set smarttab
  autocmd FileType python set expandtab
  autocmd FileType python set softtabstop=4
  " Folding is handled by treesitter in nvim
  " autocmd FileType python setlocal foldmethod=syntax
  " 'cinwords' Defines keywords that start an extra indent in the next line
  autocmd FileType python setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  " run code by pressing Ctrl+r in normal mode
  au BufRead,BufNewFile *.py nnoremap <C-r> <Esc>:w<CR>:!python %<CR>
augroup END

" javascript and typescript
augroup jsconf
  au!
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType javascript,typescript,javascript.jsx,typescript.tsx,json,vue set shiftwidth=2
  autocmd FileType javascript,typescript,javascript.jsx,typescript.tsx,json,vue set tabstop=2
  autocmd FileType javascript,typescript,javascript.jsx,typescript.tsx,json,vue set expandtab
  autocmd FileType javascript,typescript,javascript.jsx,typescript.tsx,json,vue set showmatch
  " if starting a new line in the middle of a comment, auto insert comment leader characters
  autocmd FileType javascript,typescript,javascript.jsx,typescript.tsx,vue set formatoptions+=ro
augroup END

" golang
augroup goconf
  au!
  autocmd FileType go set shiftwidth=4
  autocmd FileType go set tabstop=4
  autocmd FileType go set softtabstop=4
  autocmd FileType go set noexpandtab
augroup END

" rust
augroup rustconf
  autocmd FileType rust set shiftwidth=4
  autocmd FileType rust set tabstop=4
  autocmd FileType rust set softtabstop=4
  autocmd FileType rust set expandtab
  " run code by pressing Ctrl+r in normal mode
  au BufRead,BufNewFile *.rs nnoremap <C-r> <Esc>:w<CR>:!cargo run %<CR>
augroup END
