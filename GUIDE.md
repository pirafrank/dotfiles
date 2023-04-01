# Shortcuts, Commands, Aliases & Functions

Here's a simple getting started for who might be interested in understanding my terminal config, or for my future self.

## Notes

I use `less` as pager.

`PATH` is populated as follows (in order):

  - `$HOME/bin2`
  - `$HOME/dotfiles/bin`
  - `/opt/local/{bin,sbin}`
  - `/usr/local/{bin,sbin}`
  - `$PATH`

as stated in `zsh/common/zsh_env`.

`~/.zsh_custom` is automatically sourced if it exists, and `~/bin2` is automatically added to `$PATH`. Both are not part of the repo and can be used to add machine-specific customizations and other executables.

`CDPATH` is set in `zsh/common/zsh_env` file, even if I usually only set it in `~/.zsh_custom`.

I use dandavision's `delta` as diff tool for git. Settings are declared in `git/git_config.sh` script.

`grep` is aliased to `grep -i` so it's always case-insensitive.

## zsh shortcuts

|Name|Action|
|---|---|
|`ctrl+t`|open fzf|

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
|`dotfiles`|function|update dotfiles repo|

Check content of:

- `zsh/common/zsh_aliases` file for a full list of aliases.
- `zsh/autoloaded` dir for all available functions

## VIM

### Mappings

|Name|Action|
|---|---|
|`jj`|`Esc`|
|`ctrl+s`|rectangular selection|
|`ctrl+t`|toggle number and sign column|
|`ctrl+y`|toggle paste mode (avoid tab increments while pasting content)|
|`F9`|open tagbar|

### Splits

|Name|Action|
|---|---|
|`:split` or `:sp`|create horizontal split|
|`:vsplit` or `:vs`|create vertical split|
|`:q`|close focused split|
|`ctrl+w` `ctrl+w`|cycle between open splits|
|`ctrl+shift+j`|move to left split|
|`ctrl+w` then `ctrl+j`|move to left split (default)|
|`ctrl+shift+k`|move to top split|
|`ctrl+w` then `ctrl+k`|move to top split (default)|
|`ctrl+shift+l`|move to right split|
|`ctrl+w` then `ctrl+l`|move to right split (default)|
|`ctrl+shift+h`|move to bottom split|
|`ctrl+w` then `ctrl+h`|move to bottom split (default)|
|`ctrl+w >`|resize a vertical split to the right by a column|
|`ctrl+w 5<`|resize a vertical split to the left by 5 columns|
|`ctrl+w 5>`|resize a vertical split to the right by 5 columns|
|`ctrl+w <`|resize a vertical split to the left by a column|
|`ctrl+w +`|resize an horizontal split by one line|
|`ctrl+w -`|resize an horizontal split by one line|
|`ctrl+w 5+`|resize an horizontal split by 5 lines|
|`ctrl+w 5-`|resize an horizontal split by 5 lines|
|`ctrl+w =`|resize to equal dimensions|

More about splits [here](https://linuxhandbook.com/split-vim-workspace/).

## tmux

|Alias|Action|
|---|---|
|`tat`|list available sessions|
|`tat SESSION_NAME`|attach to session, create if it doesn't exist|
