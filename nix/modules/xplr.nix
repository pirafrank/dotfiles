{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.xplr;
  xplrPath = "${dotfilesPath}/xplr";
in
{
  config = mkIf cfg.enable {
    programs.xplr = {
      enable = true;
    };

    home.packages = with pkgs; [
      xplr
    ];

    # Link xplr configuration
    xdg.configFile = {
      "xplr/init.lua".source = "${xplrPath}/init.lua";
      "xplr/plugins.lua".source = "${xplrPath}/plugins.lua";
    };
  };
}
