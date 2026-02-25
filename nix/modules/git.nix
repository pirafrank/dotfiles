{ config, lib, pkgs, dotfilesPath, ... }:

with lib;

let
  cfg = config.programs.dotfiles.git;
  gitPath = "${dotfilesPath}/git";
in
{
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      # Aliases
      aliases = {
        co = "checkout";
        cp = "cherry-pick";
        st = "status -s";
        br = "branch";
        rb = "rebase";
        cm = "commit";
        pl = "pull";
        ps = "push";
        wt = "worktree";
        unstage = "reset HEAD --";
        refresh = "remote update origin --prune";
        rename = "branch -m";

        # Log aliases
        tree = "log --all --decorate --oneline --graph";
        adog = "log --all --decorate --oneline --graph";
        ls = "log -1 --name-status --show-signature";
        ll = "!git log --graph --pretty=format:\"%C(yellow)%h%Creset %C(yellow)%G?%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s\" $(git rev-parse --abbrev-ref HEAD) $(git rev-parse --abbrev-ref @{u})";
        la = "log --all --graph --pretty=format:\"%C(yellow)%h%Creset %C(yellow)%G?%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%ad)%Creset %C(green)%an%Creset %s\"";
        lg = "log --pretty=fuller --show-signature";
      };

      # Core settings
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autoStash = true;
        log.follow = true;
        push.autoSetupRemote = true;

        core = {
          hooksPath = "${gitPath}/hooks";
          autocrlf = false;
          eol = "lf";
          editor = "nvim";
        };

        # Delta configuration
        pager = {
          diff = "delta";
          log = "delta";
          reflog = "delta";
          show = "delta";
          blame = "delta";
        };

        diff.colorMoved = "default";
        interactive.diffFilter = "delta --color-only --features=interactive";

        delta = {
          features = "decorations";
          line-numbers = true;
          side-by-side = true;
          line-numbers-left-format = "";
          line-numbers-right-format = "│ ";

          interactive.keep-plus-minus-markers = false;

          decorations = {
            commit-decoration-style = "blue ol";
            commit-style = "raw";
            file-style = "omit";
            hunk-header-decoration-style = "blue box";
            hunk-header-file-style = "red";
            hunk-header-line-number-style = "#067a00";
            hunk-header-style = "file line-number syntax";
          };
        };
      };

      ignores = [ ];
    };

    home.packages = with pkgs; [
      git
      delta  # for better diffs
    ];

    # Link global gitignore
    home.file.".gitignore_global".source = "${gitPath}/.gitignore_global";

    # Link git hooks
    xdg.configFile."git/hooks".source = "${gitPath}/hooks";
  };
}
