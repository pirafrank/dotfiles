{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.gh;
in
{
  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;

      settings = {
        # GitHub CLI settings
        git_protocol = "ssh";
        editor = "nvim";
      };

      # Aliases from gh_config.sh
      extensions = [ ];
    };

    home.packages = with pkgs; [
      gh
    ];

    # Custom aliases set via extraConfig
    home.file.".config/gh/config.yml".text = lib.mkAfter ''
      aliases:
        url: browse --no-browser
    '';
  };
}
