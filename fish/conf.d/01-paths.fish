# PATH Configuration
# Loaded automatically by fish from conf.d/
# Uses fish_add_path which automatically handles deduplication

# Note: fish_add_path prepends by default and checks for existence
# Paths are added in reverse priority order (lowest priority first)

# System paths (lowest priority)
# These are usually already in PATH, but we ensure they're there
fish_add_path --append /usr/sbin
fish_add_path --append /usr/bin
fish_add_path --append /usr/local/sbin
fish_add_path --append /usr/local/bin

# Optional system paths
if test -d /opt/local/bin
    fish_add_path --append /opt/local/bin
end
if test -d /opt/local/sbin
    fish_add_path --append /opt/local/sbin
end

# User paths (higher priority)
if test -d "$HOME/.local/bin"
    fish_add_path "$HOME/.local/bin"
end

if test -d "$HOME/dotfiles/bin"
    fish_add_path "$HOME/dotfiles/bin"
end

if test -d "$HOME/bin2"
    fish_add_path "$HOME/bin2"
end

if test -d "$HOME/.local/share/poof/bin"
    fish_add_path "$HOME/.local/share/poof/bin"
end

# Man pages
if test -d "$HOME/.local/share/man"
    set -gx MANPATH "$HOME/.local/share/man" $MANPATH
end
if test -d "$HOME/bin2/man"
    set -gx MANPATH "$HOME/bin2/man" $MANPATH
end
