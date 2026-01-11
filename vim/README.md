# Vim/Neovim configuration

Config sets Vim as an advanced editor, Neovim as IDE-like.

## Editor Configuration

### Basic Settings

- **Encoding**: UTF-8
- **Language**: English (en_US.utf8)
- **Shell**: PowerShell on Windows
- **Auto-reload**: Files changed externally are automatically reloaded
- **Clipboard**: Uses unnamed register (`*`) for system clipboard integration
- **Terminal**: True color support enabled
- **Search**: Case-insensitive by default, case-sensitive if uppercase letters present
- **Incremental search**: Enabled
- **Syntax**: Enabled
- **Indentation**: Smart indent and auto-indent enabled
- **Default tab width**: 2 spaces (expandtab enabled)
- **Line numbers**: Absolute line numbers shown by default
- **Cursor line/column**: Highlighted
- **Sign column**: Always visible
- **Update time**: 100ms (for async updates like git diff)
- **Scroll offset**: 4 lines locked while scrolling
- **Split behavior**: New splits open below and to the right

### Keybindings

- [KEYBINDINGS.md](./KEYBINDINGS.md) - Complete keybinding reference

### Commands

- [COMMANDS.md](./COMMANDS.md) - Commands reference

### Configuration Paths

#### Vim

|Platform|Config File|Config Directory|
|---|---|---|
|Linux/macOS|`~/.vimrc`|`~/.vim/`|
|Windows|`%USERPROFILE%\.vimrc`|`%USERPROFILE%\vimfiles\`|

#### Neovim

|Platform|Config File|Config Directory|
|---|---|---|
|Linux/macOS|`~/.config/nvim/init.vim`|`~/.config/nvim/`|
|Windows|`%AppData%\Local\nvim\init.vim`|`%AppData%\Local\nvim\`|

### Backup & Swap Files

#### Vim

|Type|Location (Linux/macOS)|Location (Windows)|
|---|---|---|
|Swap|`~/.vim/swap/`|`%USERPROFILE%\vimfiles\swap\`|
|Backup|`~/.vim/backups/`|`%USERPROFILE%\vimfiles\backups\`|
|Undo|`~/.vim/undo/`|`%USERPROFILE%\vimfiles\undo\`|

#### Neovim

|Type|Location (Linux/macOS)|Location (Windows)|
|---|---|---|
|Swap|`~/.local/share/nvim/swap/`|`%USERPROFILE%\AppData\Local\nvim\swap\`|
|Backup|`~/.local/share/nvim/backups/`|`%USERPROFILE%\AppData\Local\nvim\backups\`|
|Undo|`~/.local/share/nvim/undo/`|`%USERPROFILE%\AppData\Local\nvim\undo\`|

## Plugins

### Plugins Paths (`vim-plug`)

#### Vim

|Platform|Plugin Directory|
|---|---|
|Linux/macOS|`~/.vim/plugged`|
|Windows|`%USERPROFILE%\vimfiles\plugged`|

#### Neovim

|Platform|Plugin Directory|
|---|---|
|Linux/macOS|`~/.config/nvim/plugged`|
|Windows|`%AppData%\Local\nvim\plugged`|

## Neovim GUI (neovim-qt)

- <https://github.com/equalsraf/neovim-qt>

### GUI configuration

|Platform|GUI Config|
|---|---|
|Linux/macOS|`~/.config/nvim/ginit.vim`|
|Windows|`%AppData%\Local\nvim\ginit.vim`|

### GUI Settings (gVim/neovim-qt)

- **Window size**: 140 columns × 48 lines
- **Mouse**: Enabled
- **Font**: JetBrainsMono Nerd Font Mono (size 10)

## Language Server Protocol (LSP) Support

### Enabled Languages in Neovim

The following language servers are configured and available:

#### General Purpose

|Language/Tool|LSP Server|Status|
|---|---|---|
|Bash/Shell|`bashls`|Auto-enabled|
|Docker|`dockerls`|Auto-enabled|
|Lua|`lua_ls`|Auto-enabled|
|SQL|`sqlls`|Auto-enabled|
|Terraform|`terraformls`|Auto-enabled|
|YAML|`yamlls`|Auto-enabled|

#### Programming Languages

|Language|LSP Server|Status|
|---|---|---|
|Go|`gopls`|Auto-enabled|
|Java|`jdtls`|Enabled for `.java` files|
|JavaScript/TypeScript|Via Treesitter|Syntax highlighting only|
|Python|`basedpyright`, `ruff`|Auto-enabled|
|Ruby|`ruby_lsp`|Auto-enabled|
|Rust|`rust-analyzer` (via rustaceanvim)|Auto-configured|

### Mason Packages

Mason can install LSP servers, DAP servers, linters, and formatters. Use `:Mason` to browse and install packages.

## Treesitter Parsers

The following Treesitter parsers are automatically installed:

- `bash`
- `c`
- `css`
- `dockerfile`
- `go`
- `gomod`
- `graphql`
- `html`
- `kdl`
- `java`
- `javascript`
- `json`
- `lua`
- `markdown`
- `python`
- `regex`
- `rust`
- `scss`
- `tsx`
- `typescript`
- `vim`
- `vue`
- `yaml`

Additional parsers can be installed with `:TSInstall <language>`.

## Autocomplete Sources (nvim-cmp)

Neovim autocomplete draws from these sources (in priority order):

1. **Copilot** - AI-powered suggestions
2. **LSP** - Language server completions
3. **LuaSnip** - Snippet completions
4. **nvim_lua** - Neovim Lua API completions
5. **Path** - File path completions
6. **Buffer** - Words from current buffer

## Debug

### Startup times

```sh
go install github.com/rhysd/vim-startuptime@latest
vim-startuptime
vim-startuptime -vimpath nvim
```

### CopilotChat config

Debug CopilotChat config and model in use.

```lua
:lua print(vim.inspect(require("CopilotChat.config")))
```
