# Nushell interactive configuration

$env.config = ($env.config | upsert show_banner false)
$env.config = ($env.config | upsert history { file_format: sqlite, max_size: 20000, sync_on_enter: true })

# Small wrappers keep the common zsh habits while retaining Nushell syntax.
alias nv = nvim
alias l = ls -a
alias lr = ls -a
alias lt = ls -a
alias gg = git grep -i
alias gitc = git-crypt
alias lg = lazygit
alias ldk = lazydocker
alias j = just
alias k = kubectl
alias kustomize = kubectl kustomize
alias kust = kustomize
alias terra = terraform
alias dk = docker
alias jk = bundle exec jekyll
alias ydl = youtube-dl
def epoch [] { date now | format date "%s" }
def today [] { date now | format date "%Y%m%d" }
def now [] { date now | format date "%Y-%m-%d %H:%M:%S" }
alias py = python
alias py3 = python3
alias pyc = python -m compileall
alias serve = python3 -m http.server
alias pip = python -m pip
alias npmlist = npm list --depth 0
alias npmlistg = npm list -g --depth 0
alias zjdump = zellij action dump-layout
alias glow = glow -p

def mkcd [directory: string] {
    mkdir $directory
    cd $directory
}

def gwa [branch: string] {
    let root = (^git rev-parse --show-toplevel | str trim)
    let repo = ($root | path basename)
    let suffix = ($branch | str replace --all "/" "_")
    ^git worktree add ($"../($repo)-($suffix)") $branch
}

def gwj [] {
    if (which fzf | is-empty) {
        print "gwj requires fzf"
        return
    }
    let selected = (^git worktree list | fzf | str trim)
    if ($selected | is-not-empty) {
        cd ($selected | split row " " | get 0)
    }
}

alias gwb = git worktree add -b
alias gwr = git worktree remove
alias gwp = git worktree prune
alias gwre = git worktree repair

def gwl [] {
    ^git worktree list --porcelain
    | lines
    | where ($it | str starts-with "branch ")
    | each { |line| $line | str replace "branch refs/heads/" "" }
}

def dotup [] {
    let branch = (^git branch --show-current | str trim)
    if $branch == "main" {
        ^git pull --rebase --autostash origin main
    } else {
        print $"Current branch: ($branch)"
    }
}

def dos2unix [...files: string] {
    for file in $files {
        let content = (open --raw $file | str replace --all "\r\n" "\n")
        $content | save --force $file
    }
}

def all2unix [] {
    glob "**/*"
    | where { |file| ($file | path type) == "file" }
    | each { |file| dos2unix $file }
}

def randompin [] { random int 100000..999999 }
def diceroller [] { random int 1..6 }
def myip [] { http get "https://ipinfo.io/json" }

def __nu_file_manager [command: string] {
    let target = ($nu.temp-path | path join $"nu-cwd-(random uuid).txt")
    if $command == "yazi" {
        ^yazi --cwd-file $target
    } else {
        ^$command
    }
    if ($target | path exists) {
        let directory = (open --raw $target | str trim)
        if ($directory | is-not-empty) { cd $directory }
        rm $target
    }
}

def yy [] { __nu_file_manager "yazi" }
def lf [] { __nu_file_manager "lf" }
def fff [] { __nu_file_manager "fff" }
def tere [] { __nu_file_manager "tere" }

def zj [...args: string] {
    if ($args | is-empty) { zellij } else { zellij ...$args }
}

def tat [name?: string] {
    let session = ($name | default "main")
    tmux attach -t $session; or tmux new -s $session
}

def __nu_git_prompt [] {
    let result = (^git status --porcelain --branch | complete)
    if $result.exit_code != 0 { return "" }
    let lines = ($result.stdout | lines)
    if ($lines | is-empty) { return "" }
    let header = ($lines | first | str replace "## " "")
    let dirty = if (($lines | length) > 1) { " ✚" } else { "" }
    $"(ansi yellow)($header)($dirty)(ansi reset)"
}

def __nu_prompt [] {
    let status = ($env.LAST_EXIT_CODE? | default 0)
    let marker = if $status == 0 { (ansi magenta) + "❯" } else { (ansi red) + $"✘($status) ❯" }
    $"(ansi blue)($env.PWD | path basename)(ansi reset) (__nu_git_prompt)\n($marker)(ansi reset) "
}

def __nu_right_prompt [] {
    let duration = ($env.CMD_DURATION_MS? | default 0 | into int)
    let elapsed = if $duration >= 5000 { $" ($duration) ms" } else { "" }
    $"(ansi dark_gray)(date now | format date '%H:%M:%S')($elapsed)(ansi reset)"
}

$env.PROMPT_COMMAND = {|| __nu_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| __nu_right_prompt }
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""

if not ($nu.cache-dir | path exists) {
    mkdir $nu.cache-dir
}

if (which zoxide | is-not-empty) {
    let zoxide_config = ($nu.cache-dir | path join "zoxide.nu")
    zoxide init nushell | save --force $zoxide_config
}

if (which direnv | is-not-empty) {
    direnv hook nu | save --force ($nu.cache-dir | path join "direnv.nu")
}

$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [] | append {||
    if ($nu.os-info.name == "linux") {
        print -n $"\e]7;file://(hostname)($env.PWD | url encode)\e\\"
    }
})

# Optional custom.nu is not dynamically sourced because source requires a parse-time constant path.




