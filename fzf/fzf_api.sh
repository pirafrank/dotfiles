
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

_fzf_complete_wget() {
  _fzf_complete --header-lines=6  --prompt="wget> " -- "$@" < <(
    wget --help
  )
}

_fzf_complete_wget_post() {
  awk '{print $1}' | cut -d ',' -f -1
}

_fzf_complete_terra() {
  _fzf_complete --header-lines=1  --prompt="terraform> " -- "$@" < <(
    subcommand=$(printf "$@" | cut -d' ' -f2)
    terraform $subcommand -help | awk 'tolower($0) ~ /commands:|options:/,0'
  )
}

_fzf_complete_terra_post() {
  awk '{print $1}' | cut -d ',' -f -1
}

_fzf_complete_rustc() {
  _fzf_complete --header-lines=2  --prompt="rustc> " -- "$@" < <(
    rustc --help -v
  )
}

_fzf_complete_rustc_post() {
  awk '{print $1}' | cut -d ',' -f -1
}

_fzf_complete_deno(){
    _fzf_complete --header-lines=1  --prompt="deno> " -- "$@" < <(
        deno --help | awk '/Commands:/,0' | sed '/Environment variables/q' | head -n -1
    )
}

_fzf_complete_deno_post() {
  awk '{print $1}' | cut -d ',' -f -1
}
