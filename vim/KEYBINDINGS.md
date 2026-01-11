# Vim & Neovim Keybindings

This document lists all available keybindings for both Vim and Neovim configurations.

> [!IMPORTANT]
> This reference is for commands defined in the `vim/` configuration directory of this repo. Not Vim/Neovim defaults.

## Legend

- **Mode**: `n` = Normal, `i` = Insert, `v` = Visual, `x` = Visual block, `t` = Terminal, `!` = Insert and Command-line
- **Leader key**: `<Space>`

## Common Keybindings

These keybindings work in both Vim and Neovim.

### Basic Navigation

|Keybinding|Mode|Action|
|---|---|---|
|`jj`|Insert|Exit insert mode (same as `Esc`)|
|`<Space>`|Normal|Leader key prefix|

### Folding

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>z`|Normal|Toggle fold under cursor|
|`za`|Normal|Toggle fold under cursor|
|`zc`|Normal|Close fold under cursor|
|`zo`|Normal|Open fold under cursor|
|`zM`|Normal|Close all folds|
|`zR`|Normal|Open all folds|
|`zj`|Normal|Move to next fold|
|`zk`|Normal|Move to previous fold|

### Search & Highlighting

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>n`|Normal|Turn off search highlighting|

### Buffer Management

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>b`|Normal|List buffers and prompt for buffer selection|
|`<leader>>`|Normal|Next buffer|
|`<leader><`|Normal|Previous buffer|

### Visual Selection

|Keybinding|Mode|Action|
|---|---|---|
|`<C-s>`|Visual|Rectangular/block visual selection|

### Window/Split Management

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>w`|Normal|Cycle between split windows|
|`<leader>sv`|Normal|Split window vertically|
|`<leader>sh`|Normal|Split window horizontally|
|`<C-A-j>`|Normal|Move to left split|
|`<C-A-k>`|Normal|Move to top split|
|`<C-A-l>`|Normal|Move to right split|
|`<C-A-h>`|Normal|Move to bottom split|

**Note**: Default Vim split navigation also available:

- `<C-w><C-w>` - cycle between splits
- `<C-w><C-j>` - move to left split
- `<C-w><C-k>` - move to top split
- `<C-w><C-l>` - move to right split
- `<C-w><C-h>` - move to bottom split
- `<C-w>>` - resize vertical split right by 1 column
- `<C-w><` - resize vertical split left by 1 column
- `<C-w>+` - resize horizontal split up by 1 line
- `<C-w>-` - resize horizontal split down by 1 line
- `<C-w>=` - resize splits to equal dimensions

### Line Numbers

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>1`|Normal|Toggle between absolute and relative line numbers|
|`<leader>tl`|Normal|Toggle number and sign columns on/off|

### Paste Mode

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>y`|Normal|Toggle paste mode (prevents auto-indent when pasting)|

## Vim-Only Keybindings

These keybindings are specific to Vim (not Neovim).

### File Navigation

|Keybinding|Mode|Action|
|---|---|---|
|`<C-p>`|Normal|Open fzf file finder|
|`<C-p>`|Insert|Open fzf file finder|
|`<leader>gg`|Normal|Open ripgrep live grep with fzf|
|`<leader>P`|Normal|Open CtrlP file finder (override default)|
|`<leader>p`|Normal|Open CtrlP in mixed mode (all entry types)|
|`<leader>b`|Normal|Open CtrlP buffer list|
|`<leader>r`|Normal|Open CtrlP MRU (most recently used) files|

### File Tree

|Keybinding|Mode|Action|
|---|---|---|
|`<C-n>`|Normal|Toggle NERDTree file explorer|

### Tags/Symbols

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>vv`|Normal|Toggle Tagbar (right sidebar with tags)|

### Language-Specific (Vim)

#### Python

|Keybinding|Mode|Action|
|---|---|---|
|`<C-r>`|Normal|Save and run current Python file|

#### Rust

|Keybinding|Mode|Action|
|---|---|---|
|`<C-r>`|Normal|Save and run current Rust file with `cargo run`|

#### Go

|Keybinding|Mode|Action|
|---|---|---|
|`.`|Insert|Trigger autocomplete in Go files|

## Neovim-Only Keybindings

These keybindings are specific to Neovim (not Vim).

### Basic Remappings

|Keybinding|Mode|Action|
|---|---|---|
|`Y`|Normal|Yank entire line (reverted to Vim behavior)|

### Jumping Around

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>j`|Normal|Jump to word (Hop plugin)|

### File Navigation (Telescope)

|Keybinding|Mode|Action|
|---|---|---|
|`<C-p>`|Normal|Find files with Telescope|
|`<C-p>`|Insert/Command-line|Find files with Telescope|
|`<leader>p`|Normal|Show frequent files (Frecency)|
|`<leader>ff`|Normal|Find files with Telescope|
|`<leader>gf`|Normal|Find Git tracked files|
|`<leader>gg`|Normal|Live grep in project|

### Buffer & File Management

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>/`|Normal|Fuzzy find in current buffer|
|`<leader>b`|Normal|List and search buffers|
|`<leader>r`|Normal|Recent/old files|

### Help & Documentation

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>hh`|Normal|Search help tags|
|`<leader>hk`|Normal|Search keymaps|
|`<leader>hc`|Normal|Search commands|

### Git Integration

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>gl`|Normal|Git commit log/history|
|`<leader>gb`|Normal|Git history of current buffer|

### File Tree

|Keybinding|Mode|Action|
|---|---|---|
|`<C-n>`|Normal|Toggle Neo-tree file explorer|

### Sidebar (Vista)

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>vv`|Normal|Toggle Vista sidebar (symbols/tags)|

### Bookmarks

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>mm`|Normal|Toggle bookmark on current line|
|`<leader>mg`|Normal|Go to bookmark|
|`<leader>mc`|Normal|Show bookmark commands|
|`<leader>mt`|Normal|Open bookmark tree|

### LSP (Language Server Protocol)

#### General LSP

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>2`|Normal|Toggle virtual text (inline diagnostics)|

#### Navigation

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>gd`|Normal|Go to definition|
|`<leader>gc`|Normal|Go to declaration|
|`<leader>gt`|Normal|Go to type definition|
|`<leader>gi`|Normal|Go to implementation|

#### Symbols & References

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>ll`|Normal|List document symbols|
|`<leader>lf`|Normal|Find references|
|`<leader>lw`|Normal|Search workspace symbols|

#### Diagnostics

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>ld`|Normal|Show diagnostics|
|`<leader>l[`|Normal|Go to previous diagnostic|
|`<leader>l]`|Normal|Go to next diagnostic|

#### Actions & Refactoring

|Keybinding|Mode|Action|
|---|---|---|
|`<leader>la`|Normal|Show code actions|
|`<leader>lr`|Normal|Rename symbol|
|`<leader>ls`|Normal|Show hover documentation|

### Terminal

|Keybinding|Mode|Action|
|---|---|---|
|`<C-t>`|Normal|Open/toggle terminal split|
|`jj`|Terminal|Exit terminal insert mode|
|`<C-t>`|Terminal|Exit terminal insert mode and close terminal|

### Floaterm (Floating Terminal)

|Keybinding|Mode|Action|
|---|---|---|
|`<C-t><C-n>`|Normal|Open new Floaterm|
|`<C-t><C-n>`|Terminal|Open new Floaterm|
|`<C-t><C-t>`|Normal|Toggle Floaterm|
|`<C-t><C-t>`|Terminal|Toggle Floaterm|
|`<C-t><C-k>`|Normal|Kill Floaterm|
|`<C-t><C-k>`|Terminal|Kill Floaterm|
|`<F10>`|Normal|Switch to previous Floaterm|
|`<F10>`|Terminal|Switch to previous Floaterm|
|`<F11>`|Normal|Switch to next Floaterm|
|`<F11>`|Terminal|Switch to next Floaterm|
|`<F12>`|Normal|Toggle Floaterm|
|`<F12>`|Terminal|Toggle Floaterm|

### Copilot & AI

|Keybinding|Mode|Action|
|---|---|---|
|`<C-i>`|Normal|Toggle Copilot Chat|
|`<leader>ccb`|Normal|Copilot Chat with current buffer|
|`<leader>cch`|Normal|Show Copilot help actions|
|`<leader>ccf`|Normal/Visual|Copilot Chat fix code|
|`<leader>cce`|Normal/Visual|Copilot Chat explain code|

### Autocomplete (nvim-cmp)

When the autocomplete menu is visible:

|Keybinding|Mode|Action|
|---|---|---|
|`<C-Space>`|Insert|Trigger completion|
|`<C-x>`|Insert|Close completion menu|
|`<CR>`|Insert|Confirm selection|
|`<Down>`|Insert|Select next item|
|`<Up>`|Insert|Select previous item|
|`<C-d>`|Insert|Scroll documentation down|
|`<C-u>`|Insert|Scroll documentation up|
|`<Tab>`|Insert|Select next item|
|`<S-Tab>`|Insert|Select previous item|

### Telescope Popup (when active)

|Keybinding|Mode|Action|
|---|---|---|
|`<C-c>`|Insert|Close Telescope|
|`<Esc>`|Normal|Close Telescope|
|`?`|Insert/Normal|Show which-key help|

### Telescope fzf Actions (on selected item)

These override default fzf keybindings in Telescope:

|Keybinding|Mode|Action|
|---|---|---|
|`<C-s>`|Insert|Open in horizontal split|
|`<C-w>`|Insert|Open in vertical split|

## Plugin-Specific Notes

### vim-surround

This plugin provides keybindings for managing surrounding characters (quotes, brackets, tags, etc.).

Common operations:
- `cs"'` - change surrounding `"` to `'`
- `ds"` - delete surrounding `"`
- `ysiw"` - add `"` around current word
- In visual mode: `S"` - surround selection with `"`

### vim-commentary

- `gc` in visual mode - toggle comment on selected lines
- `gcc` in normal mode - toggle comment on current line
- `gc` + motion - toggle comment (e.g., `gcap` comments a paragraph)

### vim-paste-easy

Automatically detects paste operations and sets paste mode.

### vim-oscyank

For copying to system clipboard over SSH:
- Select text in visual mode and `:OSCYank` to copy

### Rainbow Brackets

Automatically colors matching bracket pairs (no keybindings required).

### Lexima

Automatically closes parentheses, brackets, and quotes as you type.

### Hop (Neovim)

Provides `<leader>j` for quick jumping to any word on screen.

### Oil.nvim (Neovim)

Edit filesystem like a buffer (no specific keybindings, use `:Oil` command).

