# Vim/Neovim configuration

Config sets Vim as an advanced editor, Neovim as IDE-like.

## Vim

### Configuration

`.vimrc` file:

- Linux `~/.vimrc`
- Windows `%USERPROFILE%\.vimrc`
- macOS `~/.vimrc`

`.vim` dir:

- Linux `~/.vim/`
- Windows `%USERPROFILE%\vimfiles\`
- macOS `~/.vim/`

## Neovim

### Configuration

`init.vim` file:

- Linux `~/.config/nvim/init.vim`
- Windows `%AppData%\Local\nvim\init.vim`
- macOS `~/.config/nvim/init.vim`

`nvim` dir:

- Linux `~/.config/nvim`
- Windows `%AppData%\Local\nvim`
- macOS `~/.config/nvim`

### GUI app

- <https://github.com/equalsraf/neovim-qt>

GUI configuration:

- Linux `~/.config/nvim/ginit.vim`
- Windows `%AppData%\Local\nvim\ginit.vim`
- macOS `~/.config/nvim/ginit.vim`

## Debug

```sh
go install github.com/rhysd/vim-startuptime@latest
vim-startuptime
vim-startuptime -vimpath nvim
```
