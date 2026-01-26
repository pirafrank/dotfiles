# Core Environment Variables
# Loaded automatically by fish from conf.d/

# Editors
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER less

# Language settings
if not set -q LANG
    set -gx LANG en_US.UTF-8
    set -gx LC_ALL $LANG
end

# Paths
set -gx DOTFILES "$HOME/dotfiles"

# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# Less configuration
# -g: highlight only last match for searches
# -i: ignore case in searches
# -M: long prompt with more info
# -R: output ANSI color escape sequences in raw form
# -S: chop long lines (don't wrap)
# -w: highlight first new line after forward movement
# -z-4: keep 4 lines overlapping when scrolling
set -gx LESS "-g -i -M -R -S -w -z-4"

# Less input preprocessor
if command -v lesspipe >/dev/null
    set -gx LESSOPEN "| /usr/bin/env lesspipe %s 2>&-"
else if command -v lesspipe.sh >/dev/null
    set -gx LESSOPEN "| /usr/bin/env lesspipe.sh %s 2>&-"
end

# Sort order preference (Linux only)
if test (uname -s) = "Linux"
    set -gx LC_COLLATE en_US.utf8
end

# Ripgrep configuration
set -gx RIPGREP_CONFIG_PATH "$HOME/dotfiles/rg/.ripgreprc"

# Zellij custom config path
set -gx ZELLIJ_CONFIG_DIR "$HOME/dotfiles/zellij"

# bat (cat clone with syntax highlighting)
set -gx BAT_STYLE "changes,header,numbers,snip"
