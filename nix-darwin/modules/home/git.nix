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

      # apple-terminal is bat's theme (see bat.nix); delta reads bat's theme
      # cache, so diff syntax uses the same palette as `bat`. Only the diff
      # signal is colored on top: green added, red removed, yellow commits.
      syntax-theme = "apple-terminal";
      minus-style = "syntax #200f0d";
      minus-emph-style = "syntax #3f1e19";
      plus-style = "syntax #131f14";
      plus-emph-style = "syntax #263b28";
      zero-style = "syntax";
      whitespace-error-style = "#b45648 reverse";
      line-numbers-minus-style = "#b45648";
      line-numbers-plus-style = "#6caa71";
      line-numbers-zero-style = "#465c6d";
      line-numbers-left-style = "#35424c";
      line-numbers-right-style = "#35424c";
      hunk-header-style = "file line-number syntax";
      hunk-header-decoration-style = "#35424c box";
      # Stock hunk headers use delta's built-in blue for the path and line.
      hunk-header-file-style = "#e0e0e0";
      hunk-header-line-number-style = "#7b8c99";
      file-style = "bold #e0e0e0";
      file-decoration-style = "#35424c ul";
      commit-style = "bold #e5c872";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # Bright white for focus, yellow for marked commits, gray for everything
      # structural, red kept only for unstaged changes.
      gui.theme = {
        activeBorderColor = [ "#e5eff5" "bold" ];
        inactiveBorderColor = [ "#465c6d" ];
        searchingActiveBorderColor = [ "#e5c872" "bold" ];
        optionsTextColor = [ "#7b8c99" ];
        defaultFgColor = [ "#e0e0e0" ];
        selectedLineBgColor = [ "reverse" ];
        inactiveViewSelectedLineBgColor = [ "#273d4c" ];
        cherryPickedCommitBgColor = [ "#273d4c" ];
        cherryPickedCommitFgColor = [ "#e5c872" ];
        markedBaseCommitBgColor = [ "#273d4c" ];
        markedBaseCommitFgColor = [ "#e5c872" ];
        unstagedChangesColor = [ "#b45648" ];
      };

      # Without these, lazygit hashes author names and branch names onto its
      # own built-in color wheel, which puts purple initials in the log.
      gui.authorColors."*" = "#a9b5bf";
      gui.branchColors."*" = "#dee5eb";
      # lazygit 0.60+ takes a pagers array; the old git.paging object makes
      # lazygit try to rewrite its own config, which fails on a store symlink.
      git.pagers = [ { pager = "delta --paging=never"; } ];
    };
  };
}

