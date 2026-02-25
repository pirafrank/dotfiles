# Dotfiles Nix Module

A comprehensive [home-manager](https://github.com/nix-community/home-manager) flake module for managing development tool configurations.

## Included Tools

This module configures the following 15 tools:

- **Shell**: zsh, fzf
- **Editors**: vim, neovim, helix
- **Version Control**: git, gh (GitHub CLI), lazygit
- **File Managers**: lf, yazi, xplr
- **Utilities**: tmux, htop, ripgrep, zellij

## Quick Start

### Prerequisites

- Nix with flakes enabled
- home-manager installed

### Using as a Flake Input

Add this dotfiles repository as a flake input in your home-manager configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:pirafrank/dotfiles";  # or "path:/home/francesco/dotfiles"
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, dotfiles, ... }: {
    homeConfigurations."francesco" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        dotfiles.homeManagerModules.default
        {
          home.username = "francesco";
          home.homeDirectory = "/home/francesco";
          home.stateVersion = "24.05";
          
          # Enable all dotfiles
          programs.dotfiles.enable = true;  # Enables all 15 tools
        }
      ];
    };
  };
}
```

### Using with Local Path

If you have the dotfiles cloned locally:

```nix
{
  inputs.dotfiles.url = "path:/home/francesco/dotfiles";
}
```

## Configuration

### Enable All Tools (Default)

```nix
programs.dotfiles.enable = true;
```

This enables all 15 tools with their configurations.

### Selective Tool Configuration

Enable only specific tools:

```nix
programs.dotfiles = {
  enable = true;
  enableAll = false;  # Disable all by default
  
  # Enable only the tools you want
  zsh.enable = true;
  nvim.enable = true;
  git.enable = true;
  tmux.enable = true;
  fzf.enable = true;
};
```

### Mix and Match

Enable all except specific tools:

```nix
programs.dotfiles = {
  enable = true;
  enableAll = true;  # Enable all by default
  
  # Disable specific tools
  vim.enable = false;
  helix.enable = false;
};
```

## Per-Tool Options

Each tool can be individually controlled:

- `programs.dotfiles.zsh.enable` - Zsh with Zprezto framework
- `programs.dotfiles.fzf.enable` - Fuzzy finder
- `programs.dotfiles.vim.enable` - Vim with vim-plug
- `programs.dotfiles.nvim.enable` - Neovim (uses vim configs)
- `programs.dotfiles.git.enable` - Git with delta, aliases, and hooks
- `programs.dotfiles.gh.enable` - GitHub CLI with aliases
- `programs.dotfiles.lazygit.enable` - Terminal UI for git
- `programs.dotfiles.helix.enable` - Modern modal editor
- `programs.dotfiles.htop.enable` - Interactive process viewer
- `programs.dotfiles.lf.enable` - Terminal file manager
- `programs.dotfiles.ripgrep.enable` - Fast grep alternative
- `programs.dotfiles.tmux.enable` - Terminal multiplexer with TPM
- `programs.dotfiles.xplr.enable` - Hackable file explorer
- `programs.dotfiles.yazi.enable` - Blazing fast file manager
- `programs.dotfiles.zellij.enable` - Modern terminal workspace

## What Gets Configured

### Shell (zsh)
- Zprezto framework with custom runcoms
- Common aliases and functions
- Completions and autoloaded functions
- P10k prompt configuration

### Editors
- **vim/nvim**: Full .vimrc with lua configs, vim-plug, LSP, treesitter
- **helix**: Modern keybindings and language server configurations

### Version Control
- **git**: Comprehensive aliases, delta integration, hooks, global gitignore
- **gh**: GitHub CLI with custom aliases
- **lazygit**: Full TUI configuration

### File Managers
- **lf**: Custom keybindings, icons, and preview script
- **yazi**: Complete config with themes and keymaps
- **xplr**: Lua configuration with plugins

### Utilities
- **tmux**: Configuration with TPM plugin manager
- **htop**: Custom columns and display settings
- **ripgrep**: Custom search configuration via RIPGREP_CONFIG_PATH
- **zellij**: Config with custom layouts and themes

## Package Management

This module automatically installs all enabled tools via Nix. Each tool module includes:

1. Package installation via `home.packages`
2. Configuration file linking via `xdg.configFile` or `home.file`
3. Environment variables where needed (e.g., `RIPGREP_CONFIG_PATH`)
4. Plugin managers where applicable (vim-plug, TPM)

## Development

### Testing Changes

1. Navigate to the nix directory:
   ```bash
   cd /path/to/dotfiles/nix
   ```

2. Check flake validity:
   ```bash
   nix flake check
   ```

3. Test with the example configuration:
   ```bash
   home-manager switch --flake .#x86_64-linux
   ```

4. Format code:
   ```bash
   nix fmt
   ```

### Using direnv

If you have direnv installed, the `.envrc` file will automatically load the Nix development environment when you enter the directory.

### Structure

```
nix/
├── flake.nix           # Main flake definition
├── home.nix            # Main home-manager module
├── modules/            # Individual tool modules
│   ├── zsh.nix
│   ├── fzf.nix
│   ├── vim.nix
│   ├── nvim.nix
│   ├── git.nix
│   ├── gh.nix
│   ├── lazygit.nix
│   ├── helix.nix
│   ├── htop.nix
│   ├── lf.nix
│   ├── ripgrep.nix
│   ├── tmux.nix
│   ├── xplr.nix
│   ├── yazi.nix
│   └── zellij.nix
├── .envrc              # direnv configuration
└── README.md           # This file
```

## Migration from dotbot

If you were previously using the dotbot-based installation, this Nix module replaces:

- `install.conf.yaml` symlink management
- Individual `install.sh` scripts
- Manual package installation
- Shell-based configuration scripts (git_config.sh, gh_config.sh)

### Differences

1. **Declarative**: All configuration is in Nix, not shell scripts
2. **Atomic**: home-manager activations are atomic and rollback-able
3. **Reproducible**: Exact package versions pinned via flake.lock
4. **No manual steps**: Package installation + configuration happens together

### Coexistence

The Nix module is standalone - it doesn't interfere with dotbot. You can:
- Keep dotbot for non-NixOS systems
- Use Nix module on NixOS/home-manager systems
- Files in dotfiles/ remain unchanged

## Advanced Usage

### Override Package Versions

```nix
programs.dotfiles = {
  enable = true;
};

# Override specific package
home.packages = with pkgs; [
  (neovim.override { vimAlias = true; })
];
```

### Additional Git Configuration

The git module sets sensible defaults. You can add more:

```nix
programs.git = {
  userName = "Your Name";
  userEmail = "your.email@example.com";
  signing = {
    key = "YOUR_GPG_KEY";
    signByDefault = true;
  };
};
```

### Custom Environment Variables

```nix
home.sessionVariables = {
  EDITOR = "nvim";
  VISUAL = "nvim";
  # Add more...
};
```

## Troubleshooting

### Flake not found
Ensure Nix flakes are enabled:
```bash
# In ~/.config/nix/nix.conf or /etc/nix/nix.conf
experimental-features = nix-command flakes
```

### Symlink conflicts
If home-manager complains about existing files:
```bash
# Backup and remove conflicting files
mv ~/.zshrc ~/.zshrc.backup
home-manager switch --flake .#your-config
```

### Plugin installation
- **vim/nvim**: Run `:PlugInstall` after first launch
- **tmux**: Run `<prefix> + I` to install TPM plugins
- **xplr/yazi**: Plugins are referenced but not auto-installed

### Missing commands
Ensure your shell sources home-manager's profile:
```bash
# In your shell RC file
source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
```

## License

Same as the parent dotfiles repository.

## Contributing

Improvements welcome! Please ensure:
1. Run `nix flake check` before committing
2. Test changes with `home-manager switch`
3. Update this README for new features
