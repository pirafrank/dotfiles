{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.fzf;
  fzfPath = "${dotfilesPath}/fzf";
in
{
  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    home.packages = with pkgs; [
      fzf
    ];

    # Link fzf shell integrations
    home.file = {
      ".fzf.zsh".source = "${fzfPath}/.fzf.zsh";
      ".fzf.bash".source = "${fzfPath}/.fzf.bash";
    };
  };
}
