# Setup fzf
# ---------
if [[ ! "$PATH" == */home/francesco/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/francesco/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/francesco/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/francesco/.fzf/shell/key-bindings.bash"
