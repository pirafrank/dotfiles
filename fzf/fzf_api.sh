
#
# functions that extends FZF fuzzy completion via its (experimental) APIs.
# more info: https://github.com/junegunn/fzf#custom-fuzzy-completion
#
# source this file in scripts that loads your interactive shell
#

_fzf_complete_curl() {
  _fzf_complete --header-lines=1  --prompt="curl> " -- "$@" < <(
    curl -h all
  )
}

_fzf_complete_curl_post() {
  awk '{print $1}' | cut -d ',' -f -1
}

_fzf_complete_rustc() {
  _fzf_complete --header-lines=1  --prompt="rustc> " -- "$@" < <(
    rustc --help -v
  )
}

_fzf_complete_rustc_post() {
  awk '{print $1}' | cut -d ',' -f -1
}
