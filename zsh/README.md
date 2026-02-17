# Zsh Notes

## Design Decisions

1. **Split configuration**: `zsh_env` (all shells) vs `zsh_env_interactive` (interactive only)
   - Non-interactive shells (scripts) get minimal overhead
   - Interactive shells get full feature set (FZF, zoxide, direnv)

2. **PATH priority**: User paths (`~/bin2`, `~/.local/bin`) come before system paths
   - Allows overriding system tools with custom versions
   - Language version managers (pyenv, goenv, jenv) prepend to PATH

3. **Escape sequence handling**, in zshrc:
   - Prevents dirty output when TUI apps (lazygit, etc.) exit
   - Consumes pending terminal responses

4. **Directory change hooks**: [zsh/common/chpwd.zsh](./common/chpwd.zsh)
   - `check_nvmrc()`: Auto-switch Node version when entering directory with `.nvmrc`
   - `prompt_oscseq()`: Update terminal's working directory for integration
   - Executed at shell startup AND every `cd`

## Deep dive

- [Shell Loading](./docs/SHELL_LOADING.md)
- [PATH Modifications](./docs/PATH.md)
- [Prompt Configuration](./docs/PROMPT.md)
- [Performance Optimizations](./docs/PERFORMANCE.md)

## Official documentation

- [ZSH manual](https://zsh.sourceforge.io/Doc/Release/zsh_toc.html)

## Extensibility Hooks

1. `~/.zsh_custom_pre` - Loaded before P10k instant prompt (machine-specific pre-config)
2. `~/.zsh_custom` - Loaded at end of zshrc (machine-specific post-config)
3. `~/.zsh_user_themes` - Custom prompt themes directory (disabled by default)

## Load config changes

In current shell:

```sh
exec zsh
# or if it is the default shell
exec $SHELL
```

In login scripts:

Reload any updates to shell scripts by running a login shell.

```sh
exec zsh --login
```

## File Reference

| File | Purpose | When Loaded |
|------|---------|-------------|
| [zprezto/runcoms/zshenv](zprezto/runcoms/zshenv) | Environment setup, sources zsh_env | All shells (always) |
| [common/zsh_env](common/zsh_env) | PATH configuration, tool initialization | All shells (always) |
| [zprezto/runcoms/zprofile](zprezto/runcoms/zprofile) | Browser, Rails env | Login shells only |
| [zprezto/runcoms/zshrc](zprezto/runcoms/zshrc) | Interactive configuration | Interactive shells |
| [common/zsh_env_interactive](common/zsh_env_interactive) | Interactive-only PATH, tools | Interactive shells |
| [common/zsh_aliases](common/zsh_aliases) | Command aliases | Interactive shells |
| [common/chpwd.zsh](common/chpwd.zsh) | Directory change hooks | Interactive shells |
| [zprezto/runcoms/zlogin](zprezto/runcoms/zlogin) | Background compilation | Login shells only |
| [zprezto/runcoms/zlogout](zprezto/runcoms/zlogout) | Cleanup on logout | Login shells only |

## Zprezto Module Loading

Modules loaded from [zprezto/runcoms/zpreztorc](zprezto/runcoms/zpreztorc):

- **environment**: General environment setup
- **terminal**: Terminal title/escape sequences
- **tmux**: Tmux integration
- **editor**: Key bindings and editor setup
- **history**: History settings and search
- **directory**: Directory stack and navigation
- **spectrum**: Color support
- **utility**: Common aliases and functions
- **ssh**: SSH agent management
- **completion**: Advanced completion system
- **git**: Git aliases and functions
- **syntax-highlighting**: Command syntax highlighting
- **history-substring-search**: History search with substring
- **contrib-prompt**: Additional prompt themes
- **prompt**: Prompt system (P10k)
