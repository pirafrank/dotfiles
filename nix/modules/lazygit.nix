{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.lazygit;
  lazygitPath = "${dotfilesPath}/lazygit";
in
{
  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };

    home.packages = with pkgs; [
      lazygit
    ];

    # Link lazygit configuration
    xdg.configFile."lazygit/config.yml".source = "${lazygitPath}/config.yml";
  };
}
