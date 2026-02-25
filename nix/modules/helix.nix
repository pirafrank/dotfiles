{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.helix;
  helixPath = "${dotfilesPath}/helix";
in
{
  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
    };

    home.packages = with pkgs; [
      helix
    ];

    # Link helix configuration
    xdg.configFile = {
      "helix/config.toml".source = "${helixPath}/config.toml";
      "helix/languages.toml".source = "${helixPath}/languages.toml";
    };
  };
}
