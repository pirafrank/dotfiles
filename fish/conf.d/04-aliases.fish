# Shell Aliases
# Loaded automatically by fish from conf.d/

# Configuration shortcuts
alias zshconfig="vim ~/.zshrc"
alias fishconfig="vim ~/.config/fish/config.fish"
alias omzconfig="vim ~/.oh-my-zsh"
alias sshconfig="vim ~/.ssh/config"

# History search with fzf
if type -q fzf
    alias h='history | tac | fzf'
end

# System aliases
alias g='git'
alias nv='nvim'
alias l='ls -lhA'
alias lr='ll -RA'
alias lt='ll -t'
alias wgetnc="wget --no-check-certificate"
alias sshnosave="ssh -o 'UserKnownHostsFile /dev/null'"
alias sshforget='ssh-keygen -R'
alias grep="grep -i"

# Git aliases
alias gg='git grep -i'
alias gitc='git-crypt'

# Tmux session management
alias main='tmux attach -t main; or tmux new -s main'
alias work='tmux attach -t work; or tmux new -s work'
alias tm_kill='tmux kill-session -t'
function tm_kill_unnamed
    tmux ls | grep -E '^[0-9]' | cut -d':' -f1 | xargs -I {} tmux kill-session -t {}
end

# Inline utilities
alias diceroller='shuf -i 1-6 -n 1'
alias randompin='shuf -i 100000-999999 -n 1'
alias randompass="shuf -n6 /usr/share/dict/words | sed 's/\$/-/g' | tr -d '\\n' | cut -d'-' -f1-6"

# fd/fdfind alias (Ubuntu uses fdfind package name)
if type -q dpkg
    and dpkg --get-selections 2>/dev/null | grep -q 'fd-find'
    alias fd=fdfind
end

# bat/batcat alias (Ubuntu uses batcat package name)
if type -q batcat
    alias bat='batcat'
end

# bat as cat replacement
if type -q bat
    alias cat='bat -p'
end

# Date/time utilities
alias epoch='date +%s'
alias today='date +%Y%m%d'
alias now="date '+%Y-%m-%d %H:%M:%S'"

# Network utilities
alias myip='curl ipinfo.io/json'

# dos2unix (create if not exists)
if not type -q dos2unix
    function dos2unix
        sed -i 's/\r$//' $argv
    end

    function all2unix
        find . -type f -exec dos2unix {} \;
    end
end

# Python aliases
alias py='python'
alias py2='python2'
alias py3='python3'
alias pyc='python -m compileall'
alias pyc2='python2 -m compileall'
alias pyc3='python3 -m compileall'
alias serve='python3 -m http.server'
alias pip='python -m pip'
alias pip2='python2 -m pip'
alias pip3='python3 -m pip'

# Node.js aliases
alias npmlist='npm list --depth=0'
alias npmlistg='npm list -g --depth=0'

# Docker alias
alias dk="docker"

# Kubernetes aliases
alias k='kubectl'
alias kustomize='kubectl kustomize'
alias kust='kustomize'

# Terraform alias
alias terra='terraform'

# Jekyll aliases
alias jk='bundle exec jekyll'
alias jkk="$HOME/dotfiles/bin/check_jk_running.sh"

# CLI tools
alias ydl='youtube-dl'
alias lg='lazygit'
alias ldk='lazydocker'
alias j='just'
alias zjdump='zellij action dump-layout > .zellij-layout.kdl'

# gama with GitHub token
function gama
    env GITHUB_TOKEN=(gh auth token) command gama $argv
end

# glow markdown reader
alias glow='command glow -p'
