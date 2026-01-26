# Interactive Tools Configuration
# Loaded automatically by fish from conf.d/
# Only runs in interactive shells

# Exit early if not interactive
if not status --is-interactive
    exit 0
end

# Switch to neovim if installed
if type -q nvim
    set -gx EDITOR nvim
end

# FZF (fuzzy finder)
if test -f ~/.fzf.fish
    source ~/.fzf.fish
end

# FZF configuration
if type -q fzf
    set -gx FZF_DEFAULT_OPTS '--layout=reverse'

    # Use fd/fdfind for FZF if available
    if type -q fdfind
        set -gx FZF_DEFAULT_COMMAND 'fdfind --type f --hidden --follow --exclude={.git,.idea,.sass-cache,node_modules,build,.rustup,.cache}'
    else if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude={.git,.idea,.sass-cache,node_modules,build,.rustup,.cache}'
    end

    # FZF preview alias
    if type -q batcat
        alias fp="fzf --preview 'batcat --style=numbers --color=always --line-range :500 {}'"
    else if type -q bat
        alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
    end

    # FZF API functions
    set -l fzf_api_path "$HOME/dotfiles/fzf/fzf_api.sh"
    if test -f "$fzf_api_path"
        # Note: This is a bash script. May need bass plugin or rewrite in fish
        # bass source "$fzf_api_path"
    end
end

# exa (modern ls replacement)
if type -q exa
    alias lsx='exa -G -x --color auto --icons -s type'
    alias llx='exa -l --color auto --icons -s type --git'
    alias lax='llx -a'
    alias lx='lax'
    alias ltx='llx -a -snew'
end

# kitty terminal update alias
alias kittyupdate='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'

# pgadmin docker alias (if not installed)
if not type -q pgadmin
    alias pgadmin="docker run -d --net=host --name pgadmin -e PGADMIN_DEFAULT_EMAIL='email@email.com' -e PGADMIN_DEFAULT_PASSWORD=password -e PGADMIN_LISTEN_PORT=54321 dpage/pgadmin4"
end

# xplr file manager with cd on exit
if type -q xplr
    alias xcd='cd (xplr --print-pwd-as-result)'
end

# zoxide (smart cd - fasd replacement)
if type -q zoxide
    zoxide init fish | source
else if type -q fasd
    # Legacy fallback to fasd
    # Note: fasd is bash-focused, may need bass or fish-fasd wrapper
end

# direnv (per-directory environment variables)
if type -q direnv
    direnv hook fish | source
end

# Secure ShellFish iOS app integration
if test -f "$HOME/.shellfishrc"
    # This is likely a bash script, may need adaptation
    # bass source "$HOME/.shellfishrc"
end

# GPG for SSH authentication
# Only if there's a TTY
if type -q tty
    # macOS
    if test (uname -s) = "Darwin"
        set -gx GPG_TTY (tty)
        set -gx SSH_AUTH_SOCK "$HOME/.gnupg/S.gpg-agent.ssh"
    # Linux (excluding WSL and GitHub Codespaces)
    else if test (uname -s) = "Linux"
        and not string match -q '*[Ww][Ss][Ll]*' (uname -a)
        and not string match -q '*codespaces*' (uname -a)
        set -gx GPG_TTY (tty)
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent
    end
end
