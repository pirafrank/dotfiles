{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.ripgrep;
  rgPath = "${dotfilesPath}/rg";
in
{
  config = mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
    };

    home.packages = with pkgs; [
      ripgrep
    ];

    # Link ripgrep configuration
    home.file.".ripgreprc".source = "${rgPath}/.ripgreprc";

    # Set environment variable to point to config
    home.sessionVariables = {
      RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    };
  };
}
