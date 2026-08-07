# Nushell

This is a native Nushell starting point based on the repository's zsh setup,
with the practical portability choices already used by the fish setup.

It supports Ubuntu, Debian, Ubuntu on WSL2, and Windows 11.  Optional tools are
detected from `PATH`; this configuration does not install packages.

## Installation

### Linux

First, find your Nushell configuration directory:

```nu
$nu.default-config-dir
```

Then create symlinks to the managed files:

```sh
ln -s $HOME/dotfiles/nushell/env.nu $HOME/.config/nushell/env.nu
ln -s $HOME/dotfiles/nushell/config.nu $HOME/.config/nushell/config.nu
```

### Windows

First, find your Nushell configuration directory:

```nu
$nu.default-config-dir
```

Then open a PowerShell Admin terminal to create symlinks to the managed files:

```powershell
New-Item -Type SymbolicLink -Path $env:USERPROFILE\AppData\Roaming\nushell\env.nu -Target $env:USERPROFILE\dotfiles\nushell\env.nu
New-Item -Type SymbolicLink -Path $env:USERPROFILE\AppData\Roaming\nushell\config.nu -Target $env:USERPROFILE\dotfiles\nushell\config.nu
```

*Note: Creating symlinks on Windows may also require Developer Mode enabled.*

You may install optional tools with Scoop, winget, `.exe`/`.msi` installers,
or any other method that places the command on PATH.

Reload with:

```nu
source $nu.config-path
```

## Customization

Copy `custom.nu.example` to `custom.nu` in the Nushell config directory for
machine-specific settings.  `custom.nu` is loaded after the managed config and
should not be committed.

### Linux

```sh
cp $HOME/dotfiles/nushell/custom.nu.example $HOME/.config/nushell/custom.nu
```

### Windows

```powershell
Copy-Item -Path $env:USERPROFILE\dotfiles\nushell\custom.nu.example -Destination $env:USERPROFILE\AppData\Roaming\nushell\custom.nu
```

## Included behavior

- Native two-line prompt with directory, Git state, exit status, time, and
  long-command duration.
- Rust/Cargo PATH setup and Rust-aware prompt behavior.
- Git aliases, lazygit (`lg`), Git worktree helpers, and `dotup`.
- `zoxide`, `direnv`, FZF, `bat`, `fd`, Zellij, and modern file-manager hooks
  when those commands are available.
- Core navigation, Python, Node, Docker, Kubernetes, Terraform, Jekyll, and
  utility aliases from zsh.
- Linux/WSL2 and native Windows PATH-aware behavior.

## Optional tools

On Ubuntu/Debian, install tools with apt or place binaries in `~/bin2`,
`~/.local/bin`, or another PATH directory.  On Windows, Scoop and winget are
convenient options; manually installed `.exe` and `.msi` applications work as
well when their executable directory is on PATH.

Useful optional commands include `fzf`, `fd`/`fdfind`, `bat`/`batcat`, `zoxide`,
`direnv`, `lazygit`, `lazydocker`, `zellij`, `yazi`, `lf`, `eza`, `rustc`, and
`cargo`.

## Notes for zsh users

- Variables use `$env.NAME`; PATH is a list rather than a colon-separated
  string.
- Functions use `def name [] { ... }`.
- Pipelines are structured Nushell pipelines, so many `awk`/`sed`/`cut`
  patterns are unnecessary.
- Aliases are best for simple commands; functions are used for arguments,
  conditionals, directory changes, and pipelines.

The specialized AWS, Scaleway, weather, currency, Java, and terminal-recording
helpers from zsh are intentionally not included in this first Nushell setup.
