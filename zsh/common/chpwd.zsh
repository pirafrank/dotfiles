# Description: Functions to run at dir change and at shell start.

check_nvmrc() {
  [[ -f .nvmrc ]] || return
  # node --version may fail if nvm hasn't been loaded yet and no static PATH default
  # was found; nvm use triggers the lazy-loader if nvm is defined as a function.
  [[ "$(cat .nvmrc)" != "$(node --version 2>/dev/null)" ]] && nvm use
}

prompt_oscseq() {
  printf "\033]7;file://$(hostname)/$(pwd)\033\\"
}

# call this function from chpwd() to run all chpwd functions at dir change,
# and from zshrc to run them at shell start for every new shell.
_chpwd_run_all() {
  check_nvmrc >/dev/null
  prompt_oscseq
}
