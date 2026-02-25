{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.nvim;
  vimPath = "${dotfilesPath}/vim";
in
{
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    home.packages = with pkgs; [
      neovim
      # Common neovim dependencies
      git              # for vim-plug
      curl             # for vim-plug installation
      nodejs           # for LSP and plugins
      python3          # for python-based plugins
      ripgrep          # for telescope and other plugins
      fd               # for telescope and other plugins
      tree-sitter      # for treesitter
    ];

    # Link neovim configuration (symlinks to vim config)
    xdg.configFile = {
      "nvim/init.vim".source = "${vimPath}/.vimrc";
      "nvim/lua".source = "${vimPath}/lua";
      "nvim/colors".source = "${vimPath}/.vim/colors";

      # Install vim-plug for neovim
      "nvim/autoload/plug.vim" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
          sha256 = "sha256-RRR4OonXMipQ6JJtOgZHijtfOl88FpIr7eZO8paBqk8=";
        };
      };
    };
  };
}
