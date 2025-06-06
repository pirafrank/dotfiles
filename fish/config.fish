
# Load custom/env specific stuff that needs to be loaded BEFORE Powerlevel10k.
if test -e $HOME/.zsh_custom_pre
    source $HOME/.zsh_custom_pre
end

# Enable Powerlevel10k instant prompt.
if test -r (set -q XDG_CACHE_HOME; or echo $HOME/.cache)/p10k-instant-prompt-(whoami).fish
    source (set -q XDG_CACHE_HOME; or echo $HOME/.cache)/p10k-instant-prompt-(whoami).fish
end

# Source Prezto equivalent (assuming you have a Fish equivalent setup)
if test -s $HOME/.config/fish/prezto/init.fish
    source $HOME/.config/fish/prezto/init.fish
end

# Customize to your needs...
# overrides theme set in .zpreztorc
set -g fish_prompt powerlevel10k

# enable or disable custom themes on the fly
set -g CUSTOM_THEMES_ENABLED 0

# load custom themes
if test $CUSTOM_THEMES_ENABLED -eq 1 -a -d $HOME/.zsh_user_themes
    for file in $HOME/.zsh_user_themes/prompt_*.fish
        source $file
    end
end

# custom history size
set -U fish_history 20000

# pyenv addition setup
if type -q pyenv
    pyenv init - | source
end

# bash autocompletion
for file in $HOME/dotfiles/bash/completions/*
    source $file
end

# autocompletion
if test -d $HOME/dotfiles/fish/completions
    for file in $HOME/dotfiles/fish/completions/*
        source $file
    end
end

# load interactive env
source $HOME/dotfiles/fish/common/fish_env_interactive.fish

# load aliases
source $HOME/dotfiles/fish/common/fish_aliases.fish

# lazy-load functions
for file in $HOME/dotfiles/fish/autoloaded/*
    source $file
end

# load custom/env specific stuff, but only if file exists
if test -e $HOME/.zsh_custom
    source $HOME/.zsh_custom
end

# To customize prompt, run `p10k configure` or edit ~/.p10k.fish.
if test -f ~/.p10k.fish
    source ~/.p10k.fish
end

# aws-cli autocomplete
if type -q aws_completer
    complete -c aws -a "(aws_completer)"
end

# tabtab source for packages
if test -f ~/.config/tabtab/__tabtab.fish
    source ~/.config/tabtab/__tabtab.fish
end

# run every time to cd into a directory
function chpwd --on-variable PWD
    check_nvmrc > /dev/null
    prompt_oscseq
end

function check_nvmrc
    if test -f .nvmrc -a (cat .nvmrc) != (node --version)
        nvm use
    end
end

function prompt_oscseq
    printf "\033]7;file://(hostname)/(pwd)\033\\"
end

# run these for every new shell
check_nvmrc > /dev/null
prompt_oscseq

# Turso
set -gx PATH /home/francesco/.turso $PATH



### zshenv equivalent

# skip_global_compinit equivalent
set -gx skip_global_compinit 1

# setopt noglobalrcs equivalent
set -gx noglobalrcs 1

# export SYSTEM
set -gx SYSTEM (uname -s)

# load custom environment
source $HOME/dotfiles/fish/fish_env.fish



### zprofile equivalent

# Browser
if test "$OSTYPE" = "darwin*"
    set -gx BROWSER 'open'
end

# kitty config dir
set -gx KITTY_CONFIG_DIRECTORY "$HOME/dotfiles/terminals/kitty"

# default RAILS environment
set -gx RAILS_ENV "development"



### zpreztorc equivalent

# General
# Set case-sensitivity for completion, history lookup, etc.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Color output (auto set to 'no' on dumb terminals).
set -gx fish_color_normal normal

# Add additional directories to load prezto modules from
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Allow module overrides when pmodule-dirs causes module name collisions
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Set the Zsh modules to load (man zshmodules).
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Set the Zsh functions to load (man zshcontrib).
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Set the Prezto modules to load (browse modules).
# The order matters.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Autosuggestions
# Set the query found color.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Completions
# Set the entries to ignore in static */etc/hosts* for host completion.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Editor
# Set the key mapping style to 'emacs' or 'vi'.
set -g fish_key_bindings emacs

# Auto convert .... to ../..
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Allow the zsh prompt context to be shown.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Git
# Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# GNU Utility
# Set the command prefix on non-GNU systems.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# History Substring Search
# Set the query found color.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Set the query not found color.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Set the search globbing flags.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# macOS
# Set the keyword used by `mand` to open man pages in Dash.app
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Pacman
# Set the Pacman frontend.
# fish doesn't have a direct equivalent for zstyle, but you can set variables or use functions

# Prompt
# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
set -g fish_prompt_theme sorin





### zlogin equivalent

# Executes commands at login pre-zshrc.
# Fish doesn't have a direct equivalent to .zlogin, but you can place commands here that you want to run at login.




### zlogout equivalent

# Executes commands at logout.
# Fish doesn't have a direct equivalent to .zlogout, but you can place commands here that you want to run at logout.
