# Version Managers and Language Environments
# Loaded automatically by fish from conf.d/

# Python (pyenv)
if test -d "$HOME/.pyenv"
    set -gx PYENV_ROOT "$HOME/.pyenv"
    fish_add_path "$PYENV_ROOT/bin"

    if type -q pyenv
        # Initialize pyenv for fish
        # Note: pyenv init - for fish outputs fish script
        pyenv init - | source
        pyenv virtualenv-init - | source
    end
end

# Java (jenv)
if test -d "$HOME/.jenv"
    fish_add_path "$HOME/.jenv/bin"

    if type -q jenv
        jenv init - | source
    end
end

# Maven
if test -d "$HOME/bin2/maven/bin"
    fish_add_path "$HOME/bin2/maven/bin"
end

# Go (goenv or system install)
if test -d "$HOME/.goenv"
    # Use goenv
    set -gx GOENV_ROOT "$HOME/.goenv"
    fish_add_path "$GOENV_ROOT/bin"

    if type -q goenv
        goenv init - | source
        # goenv manages GOPATH and GOROOT
        if set -q GOROOT
            fish_add_path "$GOROOT/bin"
        end
        if set -q GOPATH
            fish_add_path "$GOPATH/bin"
        end
    end
else if test -d /usr/local/go/bin
    # System install
    fish_add_path /usr/local/go/bin
    set -gx GOPATH "$HOME/.golang"
    fish_add_path "$GOPATH/bin"
else if test -d "$HOME/bin2/go/bin"
    # Custom userspace install
    fish_add_path "$HOME/bin2/go/bin"
    set -gx GOPATH "$HOME/.golang"
    fish_add_path "$GOPATH/bin"
end

# Swift (Linux only, macOS has it via Xcode)
if test (uname -s) = "Linux"
    and test -d /opt/swift/usr/bin
    fish_add_path /opt/swift/usr/bin
end

# Node.js (nvm)
# Note: For fish, you might want to use a fish-specific nvm plugin like:
# - https://github.com/jorgebucaran/nvm.fish
# - Or use fnm (Fast Node Manager) which has better fish support
if test -d "$HOME/.nvm"
    set -gx NVM_DIR "$HOME/.nvm"
    # Basic nvm loading - may need bass plugin for full compatibility
    # Install bass with: fisher install edc/bass
    if test -s "$NVM_DIR/nvm.sh"
        # If you have bass installed:
        # bass source "$NVM_DIR/nvm.sh"
        # Otherwise, you may need to install a fish-specific nvm solution
    end
end

# Rust (cargo)
if test -d "$HOME/.cargo/bin"
    fish_add_path "$HOME/.cargo/bin"
end

# Kubernetes (krew)
if test -d "$HOME/.krew/bin"
    fish_add_path "$HOME/.krew/bin"
else if test -d "$KREW_ROOT/bin"
    fish_add_path "$KREW_ROOT/bin"
end

# WebAssembly - wasmer
if test -d "$HOME/.wasmer"
    set -gx WASMER_DIR "$HOME/.wasmer"
    if test -s "$WASMER_DIR/wasmer.sh"
        # This is a bash script, might need bass or manual path addition
        fish_add_path "$WASMER_DIR/bin"
    end
end

# WebAssembly - wasmtime
if test -d "$HOME/.wasmtime"
    set -gx WASMTIME_HOME "$HOME/.wasmtime"
    fish_add_path "$WASMTIME_HOME/bin"
end

# Deno
if test -d "$HOME/.deno"
    set -gx DENO_INSTALL "$HOME/.deno"
    fish_add_path "$DENO_INSTALL/bin"
end

# Serverless framework
if test -d "$HOME/.serverless/bin"
    fish_add_path "$HOME/.serverless/bin"
end

# pnpm package manager
if test -d "$HOME/.local/share/pnpm"
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    fish_add_path "$PNPM_HOME"
end

# Bun JS runtime and toolkit
if test -d "$HOME/.bun"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path "$BUN_INSTALL/bin"
end

# Terraform (tfenv)
if test -d "$HOME/.tfenv/bin"
    fish_add_path "$HOME/.tfenv/bin"
end

# Ruby (rvm)
# Note: RVM has limited fish support. Consider using rbenv instead for fish.
if test -d "$HOME/.rvm"
    # RVM for user install
    if test -s "$HOME/.rvm/scripts/rvm"
        # RVM is primarily bash-focused, you may need bass
        fish_add_path "$HOME/.rvm/bin"
    end
else if test -s /usr/local/rvm/scripts/rvm
    # RVM for root install
    fish_add_path /usr/local/rvm/bin
end

# opencode cli
if test -d "$HOME/.opencode/bin"
    fish_add_path "$HOME/.opencode/bin"
end
