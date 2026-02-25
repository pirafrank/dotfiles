{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.htop;
  htopPath = "${dotfilesPath}/htop";
in
{
  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
    };

    home.packages = with pkgs; [
      htop
    ];

    # Link htop configuration
    xdg.configFile."htop/htoprc".source = "${htopPath}/htoprc";
  };
}
