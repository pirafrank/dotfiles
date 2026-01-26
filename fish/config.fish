# Fish Shell Configuration
# Main configuration file for fish shell
# Source: ~/dotfiles/fish/config.fish

# History configuration
set -g fish_history_size 20000
set -g fish_history_limit 20000

# Disable greeting message
set -g fish_greeting

# Load custom/env specific stuff that needs to be loaded BEFORE other configs
if test -f ~/.fish_custom_pre
    source ~/.fish_custom_pre
end

# conf.d/ directory files are automatically loaded in lexical order
# This includes:
# - 00-env.fish: Core environment variables
# - 01-paths.fish: PATH setup
# - 02-version_managers.fish: Version manager initialization
# - 03-interactive.fish: Interactive tools setup
# - 04-aliases.fish: All aliases
# - 99-platform.fish: Platform-specific configurations

# Event handler: runs every time you change directory
function __fish_on_pwd_change --on-variable PWD --description 'Actions to perform on directory change'
    # Check for .nvmrc and switch node version if needed
    if test -f .nvmrc
        and type -q nvm
        set -l node_version (cat .nvmrc | string trim)
        set -l current_version (node --version 2>/dev/null | string trim)
        if test "$node_version" != "$current_version"
            nvm use >/dev/null 2>&1
        end
    end

    # Send OSC 7 sequence for terminal integration (pwd tracking)
    if status --is-interactive
        printf '\033]7;file://%s%s\033\\' (hostname) (pwd | string escape --style=url)
    end
end

# Run the pwd change hooks once at startup
__fish_on_pwd_change

# Load custom/env specific stuff, but only if file exists
if test -f ~/.fish_custom
    source ~/.fish_custom
end
