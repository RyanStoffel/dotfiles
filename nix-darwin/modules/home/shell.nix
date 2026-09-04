{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    syntaxHighlighting.enable = true;
    history.size = 50000;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons";
      cat = "bat";
      rebuild = "sudo darwin-rebuild switch --flake ~/.dotfiles/nix-darwin#macbook";
      lg = "lazygit";
      cd = "z";
      dots = "cd ~/.dotfiles";
      sshvm = "TERM=xterm-256color ssh vm";
      ai = "omp";
      tdev = "$HOME/.local/bin/tmux-dev";
      tp = "$HOME/.local/bin/tmux-project";
      t = "$HOME/.local/bin/tmux-project";
      zj = "zellij";
      zdev = "zellij -s dev -n dev";
      h = "herdr";
      hp = "$HOME/.local/bin/herdr-project";

      # Personal project aliases
      ai-usage = "$HOME/.local/bin/herdr-project personal/Ai-Usage";
      atoll = "$HOME/.local/bin/herdr-project personal/Atoll";
      better-instagram = "$HOME/.local/bin/herdr-project personal/better-instagram";
      caffeine = "$HOME/.local/bin/herdr-project personal/caffeine";
      files-stoffel = "$HOME/.local/bin/herdr-project personal/files.stoffel.org";
      forge = "$HOME/.local/bin/herdr-project personal/forge";
      homebrew-tap = "$HOME/.local/bin/herdr-project personal/homebrew-tap";
      job-tracker = "$HOME/.local/bin/herdr-project personal/job-application-tracker";
      leaderboard = "$HOME/.local/bin/herdr-project personal/leaderboard-service";
      portfolio = "$HOME/.local/bin/herdr-project personal/rstoffel-portfolio";

      # Work project aliases
      wiss = "$HOME/.local/bin/herdr-project work/WISSv5-Zeroclaw-VM";
      wiss-wiki = "$HOME/.local/bin/herdr-project work/WISSv5-Zeroclaw-VM.wiki";
      controller = "$HOME/.local/bin/herdr-project work/controller_2.2";
      wiss-installer = "$HOME/.local/bin/herdr-project work/wiss-agent-installer";
      wiss-packages = "$HOME/.local/bin/herdr-project work/wiss-packages";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      # Layout and glyphs only. Module colors are starship's defaults.
      format = "$directory$git_branch$git_status$cmd_duration$character";
      # Stock caret is a heavy angle quote; ">" is a plain ASCII caret. Green
      # and red are starship's own success/error colors.
      character.success_symbol = "[>](bold green)";
      character.error_symbol = "[>](bold red)";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };
}
