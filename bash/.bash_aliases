# vim:syntax=bash
# vim:filetype=bash

# core
alias l='ls -lhA'
alias lr='ll -RA'
alias lt='ll -t'
alias grep="grep -i"
alias wgetnc="wget --no-check-certificate"
alias dk="docker"

# ssh
alias sshnosave="ssh -o 'UserKnownHostsFile /dev/null'"
alias sshforget='ssh-keygen -R'

# git
alias gg='git grep -i'
alias gitc='git-crypt'

# tmux
alias main='tmux attach -t main || tmux new -s main'
alias work='tmux attach -t work || tmux new -s work'
alias tm_kill='tmux kill-session -t'
alias tm_kill_unnamed="tmux ls | grep -E '^[0-9]' | cut -d':' -f1 | xargs -I {} tmux kill-session -t {}"

#
# utilities
#

alias diceroller='shuf -i 1-6 -n 1'
alias randompin='shuf -i 100000-999999 -n 1'
alias randompass="shuf -n6 /usr/share/dict/words | sed 's/$/-/g' | tr -d '\n' | cut -d'-' -f1-6"
alias epoch='date +%s'

# print ip and location info
alias myip='curl ipinfo.io/json'

# print fat folders
alias ducks='du -cksh $(ls -A) | sort -hr | head -n 15'

# self made dos2unix if original one does not exist
if [[ -z $(command -v dos2unix) ]]; then
    alias dos2unix="sed -i 's/\r$//'"
    # all CRLF to LF in one shot (binary files will be automatically skipped)
    alias all2unix="find . -type f -exec dos2unix {} \;"
fi
