
" basic config utilities

let is_vim = !has('nvim')
let is_nvim = has('nvim')
let has_terminal = has('nvim') || has('terminal')
let has_gui = has("gui_running")

if is_nvim
  let $BASE = stdpath('config')
elseif is_vim
  let $BASE = '$HOME/.vim'
endif
