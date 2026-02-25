{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.zellij;
  zellijPath = "${dotfilesPath}/zellij";
in
{
  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };

    home.packages = with pkgs; [
      zellij
    ];

    # Link zellij configuration
    xdg.configFile = {
      "zellij/config.kdl".source = "${zellijPath}/config.kdl";
      "zellij/layouts".source = "${zellijPath}/layouts";
      "zellij/themes".source = "${zellijPath}/themes";
    };
  };
}
