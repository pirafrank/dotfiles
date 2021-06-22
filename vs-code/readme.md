# VS Code

## Settings and keybindings

symlink `settings.json` to:

- `~/.config/Code/User/settings.json` on Linux
- `%APPDATA%\Code\User\settings.json` on Windows
- `~/.vscode-server/data/Machine/settings.json` on WSL
- `~/Library/Application Support/Code/User/settings.json` on macOS

For example:

```sh
ln -s /home/francesco/.vscode-server/data/Machine/settings.json /home/francesco/dotfiles/vs-code/settings_sb3_wsl.json
```

Same target folder for `keybindings.json`.

## Backup extensions

Run `backup_extensions.sh FILENAME` on Linux and macOS, `backup_extensions.ps1 FILENAME` on Windows (powershell).

It will generate a restore script named *FILENAME*. Pass name without extension.

## Restore extensions

Just run restore scripts of choice.
