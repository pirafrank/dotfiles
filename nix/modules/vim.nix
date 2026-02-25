{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.vim;
  vimPath = "${dotfilesPath}/vim";
in
{
  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
    };

    home.packages = with pkgs; [
      vim
      # Common vim dependencies
      git              # for vim-plug
      curl             # for vim-plug installation
      nodejs           # for some plugins
      python3          # for python-based plugins
    ];

    # Link vim configuration
    home.file = {
      ".vimrc".source = "${vimPath}/.vimrc";
      ".vim/colors".source = "${vimPath}/.vim/colors";

      # Install vim-plug if not present
      ".vim/autoload/plug.vim" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
          sha256 = "sha256-RRR4OonXMipQ6JJtOgZHijtfOl88FpIr7eZO8paBqk8=";
        };
      };
    };

    # Link lua configuration for vim
    xdg.configFile = {
      "vim/lua".source = "${vimPath}/lua";
    };
  };
}
