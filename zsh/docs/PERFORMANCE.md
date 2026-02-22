# Zsh Performance Notes

## References

- [faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
- [function lazy loading](https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions)
- [compile completions](https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zrecompile)
- [wrapper functions](https://peterlyons.com/problog/2018/01/zsh-lazy-loading/)

## Measuring Startup Time

```sh
for i in {1..10}; do time zsh -i -c exit; done
```

Take the average of the `total` column.

To profile which lines are responsible for remaining time, uncomment in `zshrc`:

```zsh
zmodload zsh/zprof   # near the top
zprof                # at the very bottom
```

Then run `zsh -i -c exit` and inspect the output.

## Real-world tests

![Real-world startup times](./imgs/startup.png)

## Performance Optimizations

Achieving sub 200ms startup time.

The secret? Well, not so secret after all: it's lazy-loading.

### Always active (every shell invocation)

1. **Skip global compinit** (`skip_global_compinit=1` in `zshenv`) - avoids redundant completion initialization from `/etc/zshrc`.
2. **Ignore system rc files** (`setopt noglobalrcs` in `zshenv`) - only user configs are loaded.
3. **Background compilation** (`zlogin`) - `zcompile`/`zrecompile` runs in background after login shells, making subsequent loads faster via `.zwc` bytecode.
4. **Static PATH only in `zsh_env`** - `zsh_env` is sourced for every shell (including scripts and subshells). All slow `eval "$(X init ...)"` subprocess calls have been removed from it. Only fast variable assignments and path array mutations remain.
5. **Single `compinit`** - custom `fpath` entries are added *before* `source prezto/init.zsh`, so prezto's `completion` module runs `compinit` exactly once. The duplicate call that was previously in `zshrc` has been removed.

### Lazy loading (interactive shells only)

All tools below are available in interactive shells without adding cost to `zsh -i -c exit` because the heavy work is deferred.

#### Shim-based managers - binaries available immediately, zero startup cost

These managers pre-generate wrapper scripts ("shims") in a directory. Adding that directory to PATH is sufficient - no subprocess or `eval` needed.

| Manager | What's in PATH | Managed binaries |
|---------|---------------|-----------------|
| pyenv | `$PYENV_ROOT/bin` + `$PYENV_ROOT/shims` | `python`, `pip`, `python3`, … |
| jenv | `~/.jenv/bin` + `~/.jenv/shims` | `java`, `javac`, `jar`, … |
| goenv | `$GOENV_ROOT/bin` + `$GOENV_ROOT/shims` | `go`, `gofmt`, … |

Full shell integration (`eval "$(pyenv init -)"` etc.) is lazy-loaded on first call to the manager CLI itself.

#### PATH-manipulation managers - loaded via precmd one-shot hook

These managers have no shims directory: they modify PATH directly when sourced. They are loaded via a one-shot `precmd` hook that fires once, before the first interactive prompt is drawn, and then removes itself.

`precmd` hooks **do not run** during `zsh -i -c exit` (no prompt is ever drawn), so they are invisible to the startup benchmark while still making all managed binaries available the moment the shell is interactive.

| Manager | Hook | What it loads |
|---------|------|--------------|
| nvm | `_nvm_load_once` | `nvm.sh` → `node`, `npm`, `npx`, `yarn`, … |
| rvm | `_rvm_load_once` | `rvm/scripts/rvm` → `ruby`, `gem`, `bundle`, … |
| forgit | `_zplug_load_once` | `forgit.plugin.zsh` → forgit shell functions and aliases |

Note: git-cal (a command, not a plugin file) is available immediately via `$ZPLUG_HOME/bin` in PATH - set in `zshrc` at startup, not deferred.

#### Deferred chpwd (P10k warning fix)

`_chpwd_run_all` (which emits an OSC 7 terminal sequence via `prompt_oscseq` and checks `.nvmrc`) was previously called directly during `zshrc` parsing, after the p10k instant prompt block. This produced console output that p10k detected as "during initialization", triggering the warning.

It is registered as a one-shot `precmd` hook (`_defer_chpwd_startup`) that fires once before the first prompt draw - after `p10k finalize` - and then removes itself. Subsequent directory changes call it via the normal `chpwd` hook.

#### Autoloaded functions

Functions in `autoloaded/` are declared with `autoload -Uz`. Their actual function bodies are only loaded from disk on first call.

### zplug

`zplug` is no longer loaded at startup. Plugins are handled at three levels:

- **Command plugins** (e.g. git-cal): `$ZPLUG_HOME/bin` is added to PATH immediately in `zshrc` - no startup cost, available at all times.
- **Shell plugins** (e.g. forgit): sourced directly via `_zplug_load_once` precmd hook before the first prompt.
  - Note: No `zplug` declarations in the hook, or they would print `[zplug] X: already managed` to stdout, triggering the P10k instant prompt warning.
- **zplug CLI**: lazy-loaded on first explicit call to `zplug` (for `zplug update`, `zplug status`, etc.).
- **Install/update**: run `zplug_init` to install or update all declared plugins.
