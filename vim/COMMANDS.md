# Vim & Neovim Commands

This document lists all available custom commands for both Vim and Neovim configurations.

> [!IMPORTANT]
> This reference is for commands defined in the `vim/` configuration directory of this repo. Not Vim/Neovim defaults.

## Table of Contents

- [Common Commands](#common-commands)
  - [vim-plug (Plugin Manager)](#vim-plug-plugin-manager)
  - [Window Management](#window-management)
  - [Editor Information](#editor-information)
  - [File Type](#file-type)
  - [Line Numbers](#line-numbers)
  - [Tags (ctags)](#tags-ctags)
- [Vim-Only Commands](#vim-only-commands)
  - [File Navigation](#file-navigation)
  - [NERDTree](#nerdtree)
  - [Tagbar](#tagbar)
  - [ALE (Asynchronous Lint Engine)](#ale-asynchronous-lint-engine)
- [Neovim-Only Commands](#neovim-only-commands)
  - [File & Path Management](#file--path-management)
  - [Terminal](#terminal)
  - [File Navigation (Telescope)](#file-navigation-telescope)
  - [Floaterm](#floaterm)
  - [Neo-tree](#neo-tree)
  - [Vista](#vista)
  - [Oil.nvim](#oilnvim)
  - [Bookmarks](#bookmarks)
  - [LSP (Language Server Protocol)](#lsp-language-server-protocol)
  - [Language-Specific LSP Commands](#language-specific-lsp-commands)
  - [Mason (LSP/DAP/Linter Manager)](#mason-lspdaplinter-manager)
  - [Treesitter](#treesitter)
  - [Copilot](#copilot)
  - [Glow (Markdown Preview)](#glow-markdown-preview)
  - [Hop (Quick Jump)](#hop-quick-jump)

## Common Commands

These commands work in both Vim and Neovim.

### vim-plug (Plugin Manager)

|Command|Action|
|---|---|
|`:PlugInstall`|Install plugins|
|`:PlugUpdate`|Update plugins|
|`:PlugClean`|Remove unused plugins|
|`:PlugUpgrade`|Upgrade vim-plug itself|
|`:PlugStatus`|Check plugin status|
|`:PlugDiff`|Review changes from last update|

### Window Management

|Command|Action|
|---|---|
|`:split` or `:sp`|Create horizontal split|
|`:vsplit` or `:vs`|Create vertical split|
|`:Hs`|Create horizontal split (alias for `:split`)|
|`:Hsplit`|Create horizontal split (alias for `:split`)|
|`:q`|Close focused split/window|

### Editor Information

|Command|Action|
|---|---|
|`:Which`|Print whether this is Nvim or Vim|
|`:Editor`|Print the shell and EDITOR environment variable value|

### File Type

|Command|Action|
|---|---|
|`:SetLanguage <language>`|Set the filetype for current buffer|
|`:SetLang <language>`|Set the filetype for current buffer (short alias)|

### Line Numbers

|Command|Action|
|---|---|
|`:ToggleLineNumbers`|Toggle between absolute and relative line numbers|
|`:ToggleNumAndSignColumns`|Toggle number and sign columns visibility|

### Tags (ctags)

|Command|Action|
|---|---|
|`:Mktags`|Generate ctags for current project (stored in `.git/ctags`)|

## Vim-Only Commands

These commands are specific to Vim (not Neovim).

### File Navigation

|Command|Action|
|---|---|
|`:Files`|Open fzf file finder|
|`:Rg`|Open ripgrep live grep with fzf|
|`:Buffers` or `:bb`|List buffers with fzf|

### NERDTree

|Command|Action|
|---|---|
|`:NERDTreeToggle`|Toggle NERDTree file explorer|

### Tagbar

|Command|Action|
|---|---|
|`:TagbarToggle`|Toggle Tagbar (right sidebar)|

### ALE (Asynchronous Lint Engine)

ALE runs automatically. Configured linters:

- **Python**: `pylint`
- **Java**: `javac`
- **Go**: `gopls`
- **Rust**: `rls`, `cargo`

## Neovim-Only Commands

These commands are specific to Neovim (not Vim).

### File & Path Management

|Command|Action|
|---|---|
|`:PathAbsolute`|Copy current buffer's absolute path to clipboard|
|`:PathRelative`|Copy current buffer's path relative to git root to clipboard|

### Terminal

|Command|Action|
|---|---|
|`:Terminal`|Open terminal in bottom split|
|`:Term`|Toggle terminal window (smart behavior)|

The `:Term` command has smart behavior:

1. If terminal is open in split, it closes the window
2. If terminal is open in buffer, it moves to split window
3. If no terminal is running, it opens a new one in split

### File Navigation (Telescope)

|Command|Action|
|---|---|
|`:FrequentFiles`|Show frequent files using Frecency|

### Floaterm

|Command|Action|
|---|---|
|`:FloatermNew`|Open new floating terminal|
|`:FloatermToggle`|Toggle floating terminal|
|`:FloatermKill`|Kill current floating terminal|
|`:FloatermPrev`|Switch to previous floating terminal|
|`:FloatermNext`|Switch to next floating terminal|

#### Floaterm Quick Launchers

|Command|Action|
|---|---|
|`:Lg`|Launch lazygit in floating terminal|
|`:Yazi`|Launch yazi file manager in floating terminal|
|`:Xplr`|Launch xplr file manager in floating terminal|
|`:Lf`|Launch lf file manager in floating terminal|

### Neo-tree

|Command|Action|
|---|---|
|`:Neotree toggle`|Toggle Neo-tree file explorer|
|`:Neotree`|Open Neo-tree file explorer|

### Vista

|Command|Action|
|---|---|
|`:Vista!!`|Toggle Vista sidebar (symbols/tags)|
|`:Vista`|Open Vista sidebar|

### Oil.nvim

|Command|Action|
|---|---|
|`:Oil`|Open Oil file browser (edit filesystem like a buffer)|

### Bookmarks

|Command|Action|
|---|---|
|`:BookmarkToggle`|Toggle bookmark on current line|
|`:BookmarkGoto`|Go to a bookmark|
|`:BookmarksCommands`|Show all bookmark commands|
|`:BookmarksTree`|Open bookmark tree view|

### LSP (Language Server Protocol)

#### General

|Command|Action|
|---|---|
|`:LspToggleVirtualText`|Toggle inline diagnostic messages on/off|
|`:LspStart`|Start LSP for current buffer|

#### Navigation

|Command|Action|
|---|---|
|`:LspGoToDefinition`|Go to symbol definition|
|`:LspGoToDeclaration`|Go to symbol declaration|
|`:LspGoToTypeDefinition`|Go to type definition|
|`:LspGoToImplementation`|Go to implementation|

#### Symbols & Search

|Command|Action|
|---|---|
|`:LspDocumentSymbols`|List and search symbols in current document|
|`:LspFindReferences`|Find all references to symbol under cursor|
|`:LspSearchWorkspaceSymbols`|Search for symbols in entire workspace|

#### Diagnostics

|Command|Action|
|---|---|
|`:LspDiagnostics`|Show all diagnostics in Telescope|
|`:LspInLineDiagnostics`|Show diagnostics for current line in floating window|
|`:LspDiagGoToNext`|Jump to next diagnostic message|
|`:LspDiagGoToPrev`|Jump to previous diagnostic message|

#### Refactoring

|Command|Action|
|---|---|
|`:LspRenameSymbol`|Rename symbol under cursor|
|`:LspActions`|Show available code actions (quick fixes)|

#### Documentation & Info

|Command|Action|
|---|---|
|`:LspHover`|Show documentation for symbol under cursor|
|`:LspSignatureHelp`|Show function signature help|
|`:LspCodeLens`|Refresh and run code lens (inline annotations)|

#### Formatting

|Command|Action|
|---|---|
|`:LspFormatDocument`|Format current document using LSP|

### Language-Specific LSP Commands

#### Java (jdtls)

|Command|Action|
|---|---|
|`:LspOrganizeImports`|Organize and optimize imports|
|`:LspExtractVariable`|Extract selected code to variable|
|`:LspExtractMethod`|Extract selected code to method|

#### Rust (rustaceanvim)

|Command|Action|
|---|---|
|`:RustHoverActions`|Show Rust-specific hover actions|
|`:RustCodeActionGroup`|Show Rust-specific code action groups|
|`:RustLsp`|Access rust-analyzer LSP features|

### Mason (LSP/DAP/Linter Manager)

|Command|Action|
|---|---|
|`:Mason`|Open Mason UI to manage LSP servers, DAPs, linters, formatters|
|`:MasonInstall <package>`|Install a package|
|`:MasonUninstall <package>`|Uninstall a package|
|`:MasonUpdate`|Update all installed packages|

### Treesitter

|Command|Action|
|---|---|
|`:TSUpdate`|Update all installed Treesitter parsers|
|`:TSInstall <language>`|Install Treesitter parser for specific language|
|`:TSUninstall <language>`|Uninstall Treesitter parser|
|`:TSBufEnable <module>`|Enable Treesitter module for current buffer|
|`:TSBufDisable <module>`|Disable Treesitter module for current buffer|

### Copilot

|Command|Action|
|---|---|
|`:CopilotChatToggle`|Toggle Copilot Chat window|
|`:CopilotChatWithBuffer`|Start Copilot Chat with current buffer as context|
|`:CopilotChatHelp`|Show Copilot help actions|
|`:CopilotChatFix`|Ask Copilot to fix code (works in visual mode)|
|`:CopilotChatExplain`|Ask Copilot to explain code (works in visual mode)|

### Glow (Markdown Preview)

|Command|Action|
|---|---|
|`:Glow`|Preview markdown file with Glow|

### Hop (Quick Jump)

|Command|Action|
|---|---|
|`:HopWord`|Jump to any word on screen|
|`:HopChar1`|Jump to any single character on screen|
|`:HopChar2`|Jump to any two-character combination on screen|
|`:HopLine`|Jump to any line on screen|
|`:HopPattern`|Jump to any pattern match on screen|
