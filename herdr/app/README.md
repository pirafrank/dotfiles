# Herdr desktop app and Core configuration

This is a Windows desktop-app copy of the earlier Herdr setup, split by the
program that reads each file. `hc` (Herdr Core) owns terminal creation and its
default shell; Herdr app owns its window settings and keybindings.

## Herdr Core

On Windows, `install.ps1` installs `core/config_wsl.toml` as
`%APPDATA%\herdr-core\config.toml`. It sets the default Core shell to
`wsl.exe`, which starts the default WSL distribution. Linux needs no Core
override; `core/config.toml` is an empty starter if you want to keep that path
under version control.

## Herdr desktop app

The app's home is normally `%USERPROFILE%\.config\herdr-app` on Windows and
`$XDG_CONFIG_HOME/herdr-app` on Linux. `app/settings.json` and `app/keys.json`
are starter files for that directory.
The desktop app has no TUI-style prefix, so its bindings use direct shortcuts.
Ctrl+Shift+Left/Right move between tabs; Ctrl+Shift+T opens a tab; and
Ctrl+Shift+N creates a workspace. Ctrl+Shift+A opens the app's picker, while
Ctrl+Shift+[ / ] move to the previous/next agent. The app's documented
`agent.focus` command requires a terminal ID and does not offer indexed focus,
so Ctrl+1..9 cannot be assigned to agents through `keys.json`; those keys are
left unbound here. The app reloads these files while running; check for
`settings.error` or `keys.error` beside them if an edit is rejected.

Run `install.ps1` from PowerShell on Windows, or `sh install.sh` on Linux. The
shell installer also works inside WSL2 for Linux-installed Herdr components.
Both installers back up existing files with a timestamp before replacing
them, skip identical files, and leave other app-home files such as layouts and
mods alone. The shell installer installs app settings and keys under the
XDG config root; the Windows installer uses `%APPDATA%` for Core and the app's
documented `.config/herdr-app` home for the desktop app.

`keys.json` includes the desktop app's current built-in bindings along with
these custom bindings, because Herdr treats an edited keymap as user-owned on
upgrade. Review it when updating Herdr app so new built-in bindings can be
incorporated. `settings.json` stays `{}` because the app resolves `herdr-core`
through its documented search paths; the Core shell choice is set separately
in `core/config_wsl.toml` for Windows.
