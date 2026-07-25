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
      syntax-theme = "Nord";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme.selectedLineBgColor = [ "reverse" ];
      git.paging.pager = "delta --paging=never";
    };
  };
}

