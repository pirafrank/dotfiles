# Helix Editor

- <https://github.com/helix-editor/helix>
- <https://helix-editor.com/>

## Docs

- <https://docs.helix-editor.com/>
- <https://docs.helix-editor.com/configuration.html>

## Config

- Linux: `~/.config/helix/*.toml`
- macOS: `~/.config/helix/*.toml`
- Windows: `%APPDATA%\helix\*.toml`

## Install

```bash
ln -sf ~/dotfiles/helix/config.toml ~/.config/helix/config.toml
ln -sf ~/dotfiles/helix/languages.toml ~/.config/helix/languages.toml
```

## Differences from Neovim

While this configuration closely mirrors your Neovim setup, there are some differences due to Helix's design:

1. **Selection-first editing**: Helix uses a selection-first model (select then act) vs Vim's action-first model
2. **Built-in LSP**: No need for separate LSP plugins
3. **Built-in fuzzy finder**: No need for Telescope equivalent
4. **Built-in tree-sitter**: Syntax highlighting works out of the box
5. **No plugin system**: Helix is "batteries included" with most features built-in

## Tips

- Use `:config-open` to quickly edit the configuration
- Use `:config-reload` to reload configuration changes
- Use `:tutor` to learn Helix-specific commands and workflows

## Keymaps

The key mappings closely mirror your Neovim configuration:

### Normal Mode

- `z` - Toggle fold (matching `<leader>z`)
- `>` / `<` - Next/previous buffer (matching `<leader>>` / `<leader><`)
- `Ctrl+Alt+j/k/l/h` - Navigate between splits (matching Neovim split navigation)
- `Ctrl+p` - File picker (matching Telescope)
- `Ctrl+n` - File picker/sidebar (matching NERDTree/Neotree)
- `Ctrl+t` - Terminal (matching Floaterm)

### Leader Mappings

Leader is `space` key.

- `Space n` - Turn off search highlighting (matching `<leader>n`)
- `Space b` - Buffer picker (matching `<leader>b`)
- `Space p` - File picker in current directory (matching `<leader>p`)
- `Space r` - Recent files (matching `<leader>r`)
- `Space /` - Buffer search (matching `<leader>/`)
- `Space 1` - Toggle line numbers (matching `<leader>1`)
- `Space j` - Jump to word (matching hop.nvim `<leader>j`)

### LSP Mappings (Space+g)

- `Space g d` - Go to definition (matching `<leader>gd`)
- `Space g c` - Go to declaration (matching `<leader>gc`)
- `Space g t` - Go to type definition (matching `<leader>gt`)
- `Space g i` - Go to implementation (matching `<leader>gi`)

### LSP Mappings (Space+l)

- `Space l l` - Document symbols (matching `<leader>ll`)
- `Space l f` - Find references (matching `<leader>lf`)
- `Space l w` - Workspace symbols (matching `<leader>lw`)
- `Space l d` - Diagnostics (matching `<leader>ld`)
- `Space l [` / `Space l ]` - Previous/next diagnostic (matching `<leader>l[` / `<leader>l]`)
- `Space l a` - Code actions (matching `<leader>la`)
- `Space l r` - Rename symbol (matching `<leader>lr`)
- `Space l s` - Show documentation/hover (matching `<leader>ls`)

### Insert Mode

- `jj` - Exit to normal mode (matching Neovim `jj` mapping)
- `Ctrl+h` / `Ctrl+l` - Move left/right in insert mode

### Select Mode

- `y` - Copy to system clipboard and return to normal mode
- `Ctrl+_` - Toggle comments (matching vim-commentary)

## LSP Configuration

The configuration includes LSP setup for:

### Rust

- **Language Server**: `rust-analyzer`
- **Features**: Clippy on save, all cargo features, proc macros
- **Formatter**: `rustfmt`

### Python

- **Language Servers**: `pyright` and `pylsp`
- **Formatter**: `black`
- **Linting**: Disabled pycodestyle, mccabe, and pyflakes (using pyright instead)

### Lua

- **Language Server**: `lua-language-server`
- **Formatter**: `stylua`

### Java

- **Language Server**: `jdtls` (Eclipse JDT Language Server)

### JavaScript/TypeScript

- **Language Server**: `typescript-language-server`
- **Formatter**: `prettier`

### Bash

- **Language Server**: `bash-language-server`
- **Formatter**: `shfmt` (2-space indentation)

## LSP Dependencies

To use all features, install these language servers and formatters:

```bash
# Rust (install via rustup)
rustup component add rust-analyzer rustfmt clippy

# Python
pip install python-lsp-server pyright black

# Lua
# Install lua-language-server and stylua via your package manager

# Java
# Install Eclipse JDT Language Server

# JavaScript/TypeScript
npm install -g typescript-language-server prettier

# Bash
npm install -g bash-language-server
# Install shfmt via your package manager
```
