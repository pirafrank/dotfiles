# Platform-Specific Configuration
# Loaded automatically by fish from conf.d/
# Contains macOS and Linux specific settings

# Linux-specific configuration
if test (uname -s) = "Linux"
    # xclip with system clipboard selection
    if type -q xclip
        alias xclip="xclip -selection c"
    end

    # open command (like macOS)
    alias open='xdg-open'

    # Sublime Text alias (custom habits)
    if type -q subl
        alias st=subl
    end
end

# macOS-specific configuration
if test (uname -s) = "Darwin"
    # Application shortcuts
    alias st='open -a Sublime\ Text'
    alias vscode='open -a Visual\ Studio\ Code'
    alias fork='open -a /Applications/Fork.app'

    # Network listening ports
    alias listen='lsof -iTCP -sTCP:LISTEN -n -P'
end
