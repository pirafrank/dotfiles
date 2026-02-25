{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dotfiles;
  dotfilesPath = ../.;
in
{
  imports = [
    ./modules/zsh.nix
    ./modules/fzf.nix
    ./modules/vim.nix
    ./modules/nvim.nix
    ./modules/git.nix
    ./modules/gh.nix
    ./modules/lazygit.nix
    ./modules/helix.nix
    ./modules/htop.nix
    ./modules/lf.nix
    ./modules/ripgrep.nix
    ./modules/tmux.nix
    ./modules/xplr.nix
    ./modules/yazi.nix
    ./modules/zellij.nix
  ];

  options.programs.dotfiles = {
    enable = mkEnableOption "Francesco's dotfiles configuration";

    enableAll = mkOption {
      type = types.bool;
      default = true;
      description = "Enable all tools by default when dotfiles.enable is true";
    };

    zsh.enable = mkEnableOption "zsh configuration" // { default = cfg.enable && cfg.enableAll; };
    fzf.enable = mkEnableOption "fzf configuration" // { default = cfg.enable && cfg.enableAll; };
    vim.enable = mkEnableOption "vim configuration" // { default = cfg.enable && cfg.enableAll; };
    nvim.enable = mkEnableOption "neovim configuration" // { default = cfg.enable && cfg.enableAll; };
    git.enable = mkEnableOption "git configuration" // { default = cfg.enable && cfg.enableAll; };
    gh.enable = mkEnableOption "GitHub CLI configuration" // { default = cfg.enable && cfg.enableAll; };
    lazygit.enable = mkEnableOption "lazygit configuration" // { default = cfg.enable && cfg.enableAll; };
    helix.enable = mkEnableOption "helix configuration" // { default = cfg.enable && cfg.enableAll; };
    htop.enable = mkEnableOption "htop configuration" // { default = cfg.enable && cfg.enableAll; };
    lf.enable = mkEnableOption "lf configuration" // { default = cfg.enable && cfg.enableAll; };
    ripgrep.enable = mkEnableOption "ripgrep configuration" // { default = cfg.enable && cfg.enableAll; };
    tmux.enable = mkEnableOption "tmux configuration" // { default = cfg.enable && cfg.enableAll; };
    xplr.enable = mkEnableOption "xplr configuration" // { default = cfg.enable && cfg.enableAll; };
    yazi.enable = mkEnableOption "yazi configuration" // { default = cfg.enable && cfg.enableAll; };
    zellij.enable = mkEnableOption "zellij configuration" // { default = cfg.enable && cfg.enableAll; };
  };

  config = mkIf cfg.enable {
    # Export dotfiles path for use by individual modules
    _module.args.dotfilesPath = dotfilesPath;
  };
}
