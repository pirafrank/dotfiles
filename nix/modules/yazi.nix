{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.yazi;
  yaziPath = "${dotfilesPath}/yazi";
in
{
  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };

    home.packages = with pkgs; [
      yazi
    ];

    # Link yazi configuration
    xdg.configFile = {
      "yazi/yazi.toml".source = "${yaziPath}/yazi.toml";
      "yazi/keymap.toml".source = "${yaziPath}/keymap.toml";
      "yazi/theme.toml".source = "${yaziPath}/theme.toml";
      "yazi/init.lua".source = "${yaziPath}/init.lua";
    };
  };
}
