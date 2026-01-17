
""" vim-only plugin settings and mappings """

""" airline
"display all buffers in airline when there's only 1 tab open
let g:airline#extensions#tabline#enabled = 1


""" fzf config
" set fzf runtime path
set rtp+=~/.fzf
nnoremap <silent> <C-p> :Files<CR>
inoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>gg :Rg<CR>
cnoreabbrev bb Buffers
let g:fzf_preview_window = []  " disable fzf preview pane
let g:fzf_buffers_jump = 1 " [Buffers] Jump to the existing window if possible
"let g:fzf_command_prefix = 'Fzf'
" override default fzf keybindings on highlighted items in fzf popup
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-w': 'vsplit'
  \ }
" override fzf default layout
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }
" more here:
" https://github.com/junegunn/fzf/blob/master/README-VIM.md


""" ctrlp
let g:ctrlp_cmd = 'CtrlP'
"let g:ctrlp_map = '<c-p>'  " default mapping
let g:ctrlp_map = '<leader>P'  " override default mapping to use <c-p> somewhere else

" start with a tab searching all entry types
nnoremap <silent> <leader>p :CtrlPMixed<CR>
nnoremap <silent> <leader>b :CtrlPBuffer<CR>
nnoremap <silent> <leader>r :CtrlPMRU<CR>


""" ale config
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
" Python options in ale
let g:ale_python_flake8_options = '--max-line-length=88'
" Rust options in ale
let g:ale_rust_rls_toolchain = ''
let g:ale_rust_rls_executable = 'rust-analyzer'

" do not enable rustfmt, or :w will become painfully slow
" issue: https://github.com/rust-lang/rust.vim/issues/293
" let b:ale_fixers = { 'rust': ['rustfmt'] }

" same as above, due to rustfmt.
" format manually by running :RustFmt
" set g:rustfmt_autosave = 1, to format on save in rust files
let g:rustfmt_autosave = 0


""" deoplete
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


""" NerdTree
" show hidden files in nerdtree by default
let NERDTreeShowHidden=1
" use ctrl+n to toggle nerdtree
map <C-n> :NERDTreeToggle<CR>
" nerdtree uses nerdfonts
let g:NERDTreeGitStatusUseNerdFonts = 1


""" vim-signify settings
" sign settings
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = 'M'
let g:signify_sign_changedelete      = g:signify_sign_change
" show number of edited/deleted lines
let g:signify_sign_show_count = 1


""" Tagbar
nmap <leader>vv :TagbarToggle<CR>

