{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.lf;
  lfPath = "${dotfilesPath}/lf";
in
{
  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
    };

    home.packages = with pkgs; [
      lf
    ];

    # Link lf configuration
    xdg.configFile = {
      "lf/lfrc".source = "${lfPath}/lfrc";
      "lf/icons".source = "${lfPath}/icons";
      "lf/preview" = {
        source = "${lfPath}/preview";
        executable = true;
      };
    };
  };
}
