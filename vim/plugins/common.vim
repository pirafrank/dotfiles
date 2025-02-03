
""" common plugin settings and mappings """

""" airline
"display all buffers in airline when there's only 1 tab open
let g:airline#extensions#tabline#enabled = 1

""" editorconfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
let g:EditorConfig_exclude_patterns = ['scp://.\*']
let g:EditorConfig_exclude_patterns = ['oil://.\*']
let g:EditorConfig_exclude_patterns = ['oil-ssh://.\*']
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']

""" floatterm
let g:floaterm_giteditor=1
let g:floaterm_wintype='float'
let g:floaterm_width=0.9
let g:floaterm_height=0.85
let g:floaterm_position='center'
let g:floaterm_autoclose=0
let g:floaterm_opener='tabe'
let g:floaterm_autohide=1

nnoremap   <silent>   <C-t><C-n>   :FloatermNew<CR>
tnoremap   <silent>   <C-t><C-n>   <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <C-t><C-t>   :FloatermToggle<CR>
tnoremap   <silent>   <C-t><C-t>   <C-\><C-n>:FloatermToggle<CR>
nnoremap   <silent>   <C-t><C-k>   :FloatermKill<CR>
tnoremap   <silent>   <C-t><C-k>   <C-\><C-n>:FloatermKill<CR>
nnoremap   <silent>   <F10>        :FloatermPrev<CR>
tnoremap   <silent>   <F10>        <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F11>        :FloatermNext<CR>
tnoremap   <silent>   <F11>        <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F12>        :FloatermToggle<CR>
tnoremap   <silent>   <F12>        <C-\><C-n>:FloatermToggle<CR>

