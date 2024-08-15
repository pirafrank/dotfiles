" to match :vs and :vsplit behavior
command! Hs split
command! Hsplit split

" print if this is Nvim or Vim
command! Which if has('nvim') | echo "This is Nvim" | else | echo "This is Vim" | endif

" print editor in shell
command! Editor echo "SHELL '" . $SHELL . "' has EDITOR set to '" . $EDITOR . "'"

" set language for current buffer
command! -nargs=1 SetLanguage execute 'set filetype=' . <q-args>
command! -nargs=1 SetLang execute 'set filetype=' . <q-args>

" toggle between absolute and relative numbers
function! ToggleLineNumbers()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc
command! ToggleLineNumbers call ToggleLineNumbers()


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
command! ToggleNumAndSignColumns call ToggleNumAndSignColumns()
