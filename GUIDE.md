# Shortcuts, Commands, Aliases & Functions

Here's a simple getting started for who might be interested in understanding my terminal config, or for my future self.

_Warning: This is absolutely incomplete, and as any WIP it will always be._

## Notes

I use `less` as pager.

`PATH` is populated as follows (in order):

  - `$HOME/.local/share/poof/bin`
  - `$HOME/bin2`
  - `$HOME/dotfiles/bin`
  - `$HOME/.local/bin`
  - `/opt/local/{bin,sbin}`
  - `/usr/local/{bin,sbin}`
  - `$PATH`

as stated in `zsh/common/zsh_env`.

`~/.zsh_custom` is automatically sourced if it exists, and `~/bin2` is automatically added to `$PATH`. Both are not part of the repo and can be used to add machine-specific customizations and other executables.

`CDPATH` is set in `zsh/common/zsh_env` file, even if I usually only set it in `~/.zsh_custom`.

I use dandavision's `delta` as diff tool for git. Settings are declared in `git/git_config.sh` script.

`grep` is aliased to `grep -i` so it's always case-insensitive.

## fzf shortcuts

|Name|Action|
|---|---|
|`ctrl+t`|open fzf|
|`**` + <tab>|fzf custom completion API|

## git aliases

|Name|Action|
|---|---|
|`git la`|git log with tree, all branches|
|`git ll`|git log with tree, current branch and its remote, if any|
|`git ls`|git log, latest commit + signature|

## zsh functions and aliases

### Moving around

|Name|Type|Action|
|---|---|---|
|`mkcd`|function|create a dir and `cd` into it|
|`z`|alias|jump around `fasd_cd -d` (requires fasd)|
|`fzf`|exec|fuzzy finder|
|`fp`|exec|**f**ile**p**review, fuzzy finder with file preview pane powered by batcat (if installed)|
|`cat`|alias|replaced `cat` with `batcat` (if installed)|
|`fd`|alias|requires`fd-find`, includes hidden items, excludes: `.git,.idea,.sass-cache,node_modules,build,.rustup,.cache`|

### Grepping

|Name|Type|Action|
|---|---|---|
|`grep`|alias|`grep -i`, grep case-insensitive.|
|`gg`|alias|`git grep -i`, git grep case-insensitive.|

### Time

|Name|Type|Action|
|---|---|---|
|`today`|function|print current date|
|`now`|function|print current datetime|
|`epoch`|alias|print epoch in seconds|

### Network

|Name|Type|Action|
|---|---|---|
|`myip`|alias|get your public IP on Internet and location info|

### Cloud

|Name|Type|Action|
|---|---|---|
|`ghlr`|function|`gh`-last-run, monitor or view last GitHub action workflow run (requires `gh`)|
|`aws_token_clean`|function|unset `AWS_*` auth vars|
|`rat`|function|Refresh AWS Tokens, useful for MFA enabled accounts|

### Internet-powered utils

|Name|Type|Action|
|---|---|---|
|`cs`|function|show cheat sheet from cheat.sh, accepts 1 argument|
|`wth`|function|print weather|
|`rates`|function|print currency rates|

### Other

|Name|Type|Action|
|---|---|---|
|`termcolors`|function|print all available terminal colors|
|`dotup`|function|update dotfiles repo|

Check content of:

- `zsh/common/zsh_aliases` file for a full list of aliases.
- `zsh/autoloaded` dir for all available functions

## Neovim (and VIM)

Check the VIM/Neovim [README](vim/README.md) for detailed information about Vim and Neovim configurations, commands, and keybindings.

## tmux

|Alias|Action|
|---|---|
|`tat`|list available sessions|
|`tat SESSION_NAME`|attach to session, create if it doesn't exist|

## zellij

Check [README](zellij/README.md) and [KEYBINDINGS](zellij/KEYBINDINGS.md) files.
