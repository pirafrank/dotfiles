{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.tmux;
  tmuxPath = "${dotfilesPath}/tmux";
in
{
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };

    home.packages = with pkgs; [
      tmux
    ];

    # Link tmux configuration
    home.file = {
      ".tmux.conf".source = "${tmuxPath}/.tmux.conf";

      # Install TPM (Tmux Plugin Manager) if not present
      ".tmux/plugins/tpm" = {
        source = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tpm";
          rev = "v3.1.0";
          sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLotwORe0gp8R1SEAXkBc=";
        };
        recursive = true;
      };
    };
  };
}
