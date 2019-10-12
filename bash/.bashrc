# Terminal custom colors
# export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ " # shows full path
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ " # shows working dir only
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILE="$HOME/.bash_history"
HISTSIZE=10000
HISTFILESIZE=10000
