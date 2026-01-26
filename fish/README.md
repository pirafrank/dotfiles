# Fish Shell Configuration

A portable fish shell configuration ported from the zsh setup in this dotfiles repository.

## Table of Contents

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Configuration Structure](#configuration-structure)
- [Custom Functions](#custom-functions)
- [Differences from Zsh](#differences-from-zsh)
- [Platform-Specific Notes](#platform-specific-notes)
- [Version Managers](#version-managers)
- [Troubleshooting](#troubleshooting)

## About

This fish configuration is a direct port of the zsh configuration found in `~/dotfiles/zsh/`. It preserves all custom functions, aliases, environment variables, and interactive tools while leveraging fish's built-in features like syntax highlighting, autosuggestions, and smart tab completion.

## Features

- **No plugins required**: Fish comes with syntax highlighting, autosuggestions, and tab completion built-in
- **21 custom functions**: All zsh autoloaded functions ported to fish
- **Platform-aware**: Separate configurations for macOS and Linux
- **Version manager support**: pyenv, nvm, jenv, goenv, cargo, and more
- **Interactive tools**: FZF, zoxide, direnv integration
- **Comprehensive aliases**: System commands, git, tmux, docker, k8s shortcuts
- **GPG/SSH agent**: Automatic setup for different platforms

## Installation

### 1. Install Fish Shell

#### macOS

```bash
brew install fish
```

#### Ubuntu/Debian

```bash
sudo apt install fish
```

#### Arch Linux

```bash
sudo pacman -S fish
```

### 2. Install the Configuration

Symlink this dotfiles directory to fish's config location:

```bash
ln -s ~/dotfiles/fish ~/.config/fish
```

### 3. Set Fish as Default Shell (Optional)

First, add fish to the list of valid shells:

```bash
command -v fish | sudo tee -a /etc/shells
```

then change your default shell:

```bash
chsh -s $(command -v fish)
```

**Note**: On some systems (particularly some Linux distributions), you may want to keep bash/zsh as your login shell and only run fish interactively to avoid compatibility issues.

### 4. Install Optional Dependencies

For full functionality, install these tools:

```bash
# Modern CLI tools
brew install fzf fd bat exa ripgrep zoxide direnv

# File managers with cd-on-exit
brew install yazi lf

# Terminal multiplexers
brew install tmux zellij

# Version managers (as needed)
brew install pyenv nvm jenv
```

## Configuration Structure

Fish uses a different structure than zsh:

```
~/.config/fish/
├── config.fish              # Main config (loaded for every shell)
├── conf.d/                  # Auto-loaded configs (in lexical order)
│   ├── 00-env.fish         # Core environment variables
│   ├── 01-paths.fish       # PATH setup
│   ├── 02-version_managers.fish # pyenv, nvm, jenv, etc.
│   ├── 03-interactive.fish # Interactive tools (fzf, zoxide, direnv)
│   ├── 04-aliases.fish     # All aliases
│   └── 99-platform.fish    # Platform-specific (macOS/Linux)
├── functions/               # Auto-loaded functions (lazy-loaded)
│   ├── mkcd.fish
│   ├── yy.fish
│   ├── lf.fish
│   └── ... (21 functions total)
└── completions/            # Custom completions (future use)
```

### How It Works

1. **`config.fish`**: Runs for every shell (interactive and non-interactive)
   - Sets history options
   - Defines event handlers (directory change hooks)
   - Sources custom pre/post configs

2. **`conf.d/`**: Files are automatically loaded in lexical order before `config.fish`
   - No need to source them manually
   - Numbered prefixes ensure correct load order

3. **`functions/`**: Functions are automatically discovered and lazy-loaded
   - Each function in its own file
   - Only loaded when first called (performance benefit)
   - No need to declare or source them

## Custom Functions

All 21 functions from the zsh setup have been ported:

| Function | Description |
|----------|-------------|
| `mkcd` | Create directory and cd into it (or fix failed cd) |
| `yy` | Yazi file manager with cd on exit |
| `lf` | lf file manager with cd on exit |
| `fff` | fff file manager with cd on exit |
| `tere` | tere file navigator with cd on exit |
| `zj` | Smart zellij launcher (uses local layout if present) |
| `vi` | vim with minimal config |
| `dotup` | Update dotfiles repository |
| `gitignore` | Fetch gitignore templates from toptal.com |
| `ghlr` | GitHub CLI - monitor last workflow run |
| `aws_tokens_clean` | Unset AWS session tokens |
| `rat` | Refresh AWS tokens with MFA |
| `cs` | cheat.sh - community driven cheat sheets |
| `rates` | Currency exchange rates from rate.sx |
| `wth` | Weather forecast from wttr.in |
| `rec` | Wrapper around asciinema for terminal recording |
| `fix_java` | Extract Java version from pom.xml and set via jenv |
| `tat` | tmux attach helper |
| `scwupdate` | Update Scaleway CLI tool |
| `termcolors` | Display all 256 terminal colors |
| `watchexec` | Wrapper with auto-detection for different projects |

## Differences from Zsh

### What Fish Provides Built-in

Fish includes many features that require plugins in zsh:

- **Syntax highlighting**: Built-in, no need for zsh-syntax-highlighting
- **Autosuggestions**: Built-in, no need for zsh-autosuggestions
- **Tab completion**: Advanced completion with visual selection
- **Command history**: Better history search (up arrow with partial match)
- **Path deduplication**: Automatic, no manual `typeset -U` needed

### Language Differences

| Feature | Zsh | Fish |
|---------|-----|------|
| Set variable | `VAR=value` | `set VAR value` |
| Export variable | `export VAR=value` | `set -gx VAR value` |
| Local variable | `local var=value` | `set -l var value` |
| Command substitution | `$(cmd)` | `(cmd)` |
| Array access | `$array[1]` | `$array[1]` (same!) |
| Conditionals | `if [[ ... ]]; then ... fi` | `if test ...; ... end` |
| For loops | `for i in ...; do ... done` | `for i in ...; ... end` |
| Functions | `function name() { ... }` | `function name; ...; end` |

### No Separate Login/Non-login Shells

Fish doesn't distinguish between login and non-login shells like zsh does. All configuration is loaded the same way. If you need login-specific behavior, use:

```fish
if status --is-login
    # Login shell specific code
end
```

### Universal Variables

Fish has "universal variables" that persist across all sessions:

```fish
set -U my_var value  # Persists across all shells and sessions
```

Use these sparingly - most configuration should use global variables (`set -gx`).

### No Prompt Themes Like Powerlevel10k

Fish doesn't have a direct equivalent to Powerlevel10k. Options include:

- **Starship**: Cross-shell prompt (works in fish, zsh, bash)
- **Tide**: Fish-specific, similar to Powerlevel10k
- **Pure**: Minimalist prompt for fish
- Built-in prompt: `fish_config` command opens web UI to customize

## Platform-Specific Notes

### macOS

- Configured for GPG agent SSH authentication
- Application shortcuts (Sublime Text, VSCode, Fork)
- `open` command works out of the box

### Linux

- `xclip` configured for system clipboard
- `open` aliased to `xdg-open`
- Separate GPG agent setup (excludes WSL and Codespaces)

### WSL (Windows Subsystem for Linux)

The configuration detects WSL and skips Linux-specific GPG setup. For WSL-specific needs, add a custom config:

```bash
# ~/.fish_custom
if string match -q '*microsoft*' (uname -r)
    # WSL-specific configuration
end
```

## Version Managers

### Python (pyenv)

Fish initialization is different from zsh:

```fish
pyenv init - | source  # Not: eval "$(pyenv init -)"
```

### Node.js (nvm)

**Important**: The standard nvm is bash-focused. For fish, use one of:

1. **fnm** (Fast Node Manager) - Recommended for fish:
   ```bash
   brew install fnm
   fnm env --use-on-cd | source
   ```

2. **fisher + jorgebucaran/nvm.fish**:
   ```bash
   fisher install jorgebucaran/nvm.fish
   ```

3. **bass** - Run bash scripts in fish:
   ```bash
   fisher install edc/bass
   bass source ~/.nvm/nvm.sh
   ```

### Ruby (rvm)

RVM has limited fish support. Consider using **rbenv** instead:

```bash
brew install rbenv
rbenv init - | source
```

### Others

Most version managers work fine with fish:

- **jenv**: `jenv init - | source`
- **goenv**: `goenv init - | source`
- **tfenv**: Just needs to be in PATH
- **cargo**: Just needs to be in PATH

## Troubleshooting

### Functions Not Loading

Fish auto-loads functions from `~/.config/fish/functions/`. If a function isn't working:

1. Check the file exists: `ls ~/.config/fish/functions/function_name.fish`
2. Check for syntax errors: `fish -n ~/.config/fish/functions/function_name.fish`
3. Reload config: `source ~/.config/fish/config.fish`

### PATH Issues

Fish uses `fish_add_path` which automatically deduplicates and persists PATH changes. To see your PATH:

```fish
echo $PATH | tr ' ' '\n'
```

To add a path:

```fish
fish_add_path /new/path
```

### Slow Startup

Check startup time:

```bash
fish -c 'time fish -c exit'
```

Common causes:

1. **Version managers**: Each one adds ~50-100ms
2. **NVM**: Particularly slow; use fnm instead
3. **Too many functions**: Shouldn't be an issue (lazy-loaded)

Optimize by commenting out unused version managers in `conf.d/02-version_managers.fish`.

### Bash Scripts Not Working

If you have bash-specific scripts (like nvm or rvm), install **bass**:

```bash
fisher install edc/bass
bass source /path/to/script.sh
```

### Custom Configuration

To add custom configuration that won't be overwritten:

**Before other configs load**:

```bash
touch ~/.fish_custom_pre
```

**After other configs load**:

```bash
touch ~/.fish_custom
```

These files are sourced by `config.fish` if they exist.

### Migrating from Zsh

If you're used to zsh, remember:

1. No need for `export` - use `set -gx`
2. No need for quotes in most cases - fish handles spaces better
3. `test` instead of `[[ ]]` for conditionals
4. No semicolons needed - use newlines or `;`
5. Command substitution: `(cmd)` not `$(cmd)`

### Getting Help

- Fish documentation: https://fishshell.com/docs/current/
- Fish tutorial: `fish_tutorial`
- Web-based config: `fish_config`
- This dotfiles repo: https://github.com/pirafrank/dotfiles

## Additional Resources

- [Official Fish Documentation](https://fishshell.com/docs/current/)
- [Fish for bash users](https://fishshell.com/docs/current/fish_for_bash_users.html)
- [Awesome Fish](https://github.com/jorgebucaran/awsm.fish) - Curated list of fish packages
- [Fisher](https://github.com/jorgebucaran/fisher) - Fish plugin manager
