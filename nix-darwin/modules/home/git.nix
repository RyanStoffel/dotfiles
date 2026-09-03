{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Ryan Stoffel";
      user.email = "stoffel.thomas.ryan@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      merge.conflictstyle = "diff3";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;

      # crt-mono is bat's theme (see shell.nix); delta reads bat's theme cache,
      # so diff syntax uses the same palette as `bat`. Only the diff signal is
      # colored on top: green added, red removed, amber commit headers.
      syntax-theme = "crt-mono";
      minus-style = "syntax #1c0f0e";
      minus-emph-style = "syntax #3a1512";
      plus-style = "syntax #0c1a0f";
      plus-emph-style = "syntax #143d1c";
      zero-style = "syntax";
      whitespace-error-style = "#c94f42 reverse";
      line-numbers-minus-style = "#c94f42";
      line-numbers-plus-style = "#4a9e5c";
      line-numbers-zero-style = "#4a4a4a";
      line-numbers-left-style = "#303030";
      line-numbers-right-style = "#303030";
      hunk-header-style = "file line-number syntax";
      hunk-header-decoration-style = "#303030 box";
      # Stock hunk headers use delta's built-in blue for the path and line.
      hunk-header-file-style = "#e4e4e4";
      hunk-header-line-number-style = "#6f6f6f";
      file-style = "bold #e4e4e4";
      file-decoration-style = "#303030 ul";
      commit-style = "bold #ffb000";
      commit-decoration-style = "#303030 box";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # Amber for focus and marked commits, gray for everything structural, red
      # kept only for unstaged changes.
      gui.theme = {
        activeBorderColor = [ "#ffb000" "bold" ];
        inactiveBorderColor = [ "#4a4a4a" ];
        searchingActiveBorderColor = [ "#ffb000" "bold" ];
        optionsTextColor = [ "#6f6f6f" ];
        defaultFgColor = [ "#e4e4e4" ];
        selectedLineBgColor = [ "reverse" ];
        inactiveViewSelectedLineBgColor = [ "#1c1c1c" ];
        cherryPickedCommitBgColor = [ "#1c1c1c" ];
        cherryPickedCommitFgColor = [ "#ffb000" ];
        markedBaseCommitBgColor = [ "#1c1c1c" ];
        markedBaseCommitFgColor = [ "#ffb000" ];
        unstagedChangesColor = [ "#c94f42" ];
      };

      # Without these, lazygit hashes author names and branch names onto its
      # own built-in color wheel, which puts purple initials in the log.
      gui.authorColors."*" = "#9a9a9a";
      gui.branchColors."*" = "#b8b8b8";
      # lazygit 0.60+ takes a pagers array; the old git.paging object makes
      # lazygit try to rewrite its own config, which fails on a store symlink.
      git.pagers = [ { pager = "delta --paging=never"; } ];
    };
  };
}

