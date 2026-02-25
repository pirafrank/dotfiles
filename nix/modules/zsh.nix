{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.zsh;
  zshPath = "${dotfilesPath}/zsh";
in
{
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };

    home.packages = with pkgs; [
      zsh
      zsh-completions
    ];

    # Link zprezto runcoms
    home.file = {
      ".zshenv".source = "${zshPath}/zprezto/runcoms/zshenv";
      ".zshrc".source = "${zshPath}/zprezto/runcoms/zshrc";
      ".zprofile".source = "${zshPath}/zprezto/runcoms/zprofile";
      ".zlogin".source = "${zshPath}/zprezto/runcoms/zlogin";
      ".zlogout".source = "${zshPath}/zprezto/runcoms/zlogout";
      ".zpreztorc".source = "${zshPath}/zprezto/runcoms/zpreztorc";

      # Link zprezto framework
      ".zprezto".source = "${zshPath}/zprezto";
    };

    # Link common zsh configs
    xdg.configFile = {
      "zsh/common".source = "${zshPath}/common";
      "zsh/completions".source = "${zshPath}/completions";
      "zsh/autoloaded".source = "${zshPath}/autoloaded";
    };
  };
}
