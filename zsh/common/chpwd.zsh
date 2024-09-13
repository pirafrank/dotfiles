# Description: Functions to run at dir change and at shell start.

check_nvmrc() {
  if [[ -f .nvmrc ]] && [[ "$(cat .nvmrc)" != "$(node --version)" ]]; then
    nvm use
  fi
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
