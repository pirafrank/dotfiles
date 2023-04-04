""" plugin settings

" fzf options
" set fzf runtime path
set rtp+=~/.fzf
" call it via CTRL+P
nnoremap <silent> <C-p> :FZF<CR>
inoremap <silent> <C-p> :FZF<CR>
cnoreabbrev bb Buffers
let g:fzf_buffers_jump = 1 " [Buffers] Jump to the existing window if possible

" ale config
" shorter error/warning flags
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
" custom icons for errors and warnings
let g:ale_sign_error = '✘✘'
let g:ale_sign_warning = '⚠⚠'
" disable loclist at the bottom of vim
let g:ale_open_list = 0
let g:ale_loclist = 0
" Setup compilers for languages
let g:ale_linters = {
      \  'python': ['pylint'],
      \  'java': ['javac'],
      \  'go': ['gopls'],
      \  'rust': ['rls', 'cargo'],
      \ }

let g:ale_rust_rls_toolchain = ''
let g:ale_rust_rls_executable = 'rust-analyzer'

" do not enable rustfmt, or :w will become painfully slow
" issue: https://github.com/rust-lang/rust.vim/issues/293
" let b:ale_fixers = { 'rust': ['rustfmt'] }

" same as above, due to rustfmt.
" format manually by running :RustFmt
" set g:rustfmt_autosave = 1, to format on save in rust files
let g:rustfmt_autosave = 0

" enable omnicompletion (disabled by default)
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete

" deoplete config
" enable deoplete at startup
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 2
" javacomplete config
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java JCEnable " enable by default for .java files

" golang autocomplete on . keypress
au filetype go inoremap <buffer> . .<C-x><C-o>
let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor

" show hidden files in nerdtree by default
let NERDTreeShowHidden=1
" use ctrl+n to toggle nerdtree
map <C-n> :NERDTreeToggle<CR>

let g:NERDTreeGitStatusUseNerdFonts = 1

"display all buffers in airline when there's only 1 tab open
let g:airline#extensions#tabline#enabled = 1

" vim-signify settings
" default updatetime 4000ms is not good for async update
set updatetime=100
" sign settings
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = 'M'
let g:signify_sign_changedelete      = g:signify_sign_change
" show number of edited/deleted lines
let g:signify_sign_show_count = 1

" editorconfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
let g:EditorConfig_exclude_patterns = ['scp://.\*']
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']
