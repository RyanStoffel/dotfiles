{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      # Ghost text stays dim gray so a suggestion never reads as typed input.
      highlight = "fg=8";
    };

    # crt-mono highlighting, keyed to ANSI slots rather than hex so it tracks
    # whatever ghostty/config sets. Green means the word resolves to something
    # runnable, bright red means it does not, amber marks literals and history
    # expansions, gray is structure.
    syntaxHighlighting = {
      enable = true;
      styles = {
        unknown-token = "fg=9,bold";
        reserved-word = "fg=15";
        command = "fg=2";
        builtin = "fg=2";
        function = "fg=2";
        alias = "fg=2";
        precommand = "fg=2";
        arg0 = "fg=2";
        path = "fg=7";
        path_prefix = "fg=8";
        globbing = "fg=14";
        single-quoted-argument = "fg=3";
        double-quoted-argument = "fg=3";
        dollar-double-quoted-argument = "fg=14";
        back-quoted-argument = "fg=14";
        redirection = "fg=6";
        comment = "fg=8";
        assign = "fg=15";
        history-expansion = "fg=11";
      };
    };
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
      format = "$directory$git_branch$git_status$cmd_duration$character";
      # Prompt chrome is gray. The caret is the only status color in the prompt:
      # green when the last command exited zero, red when it did not.
      directory.style = "bold bright-white";
      git_branch.style = "bright-black";
      git_status.style = "bright-yellow";
      cmd_duration.style = "bright-black";
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
    # Amber marks the cursor line and the matched substring; everything else is
    # gray. "-1" keeps the terminal background instead of painting one.
    colors = {
      "fg" = "#b8b8b8";
      "fg+" = "#ffffff";
      "bg" = "-1";
      "bg+" = "#1c1c1c";
      "hl" = "#ffb000";
      "hl+" = "#ffb000";
      "info" = "#6f6f6f";
      "border" = "#303030";
      "prompt" = "#ffb000";
      "pointer" = "#ffb000";
      "marker" = "#4a9e5c";
      "spinner" = "#6f6f6f";
      "header" = "#6f6f6f";
      "gutter" = "-1";
    };
  };

  home.sessionVariables = {
    # eza ships a rainbow by default. "reset" drops all of it, then only the
    # columns that carry meaning get color: amber for executables and modified
    # git state, green for added, red for deleted or broken, teal for links.
    # Icons are pinned to gray so `ls` is not a color wheel.
    EZA_COLORS = builtins.concatStringsSep ":" [
      "reset"
      "di=1;97"
      "ex=93"
      "fi=37"
      "ln=96"
      "lp=96"
      "or=91"
      "pi=90"
      "so=90"
      "bd=90"
      "cd=90"
      "sp=90"
      "mp=90"
      "ur=97"
      "uw=97"
      "ux=93"
      "ue=93"
      "gr=90"
      "gw=90"
      "gx=90"
      "tr=90"
      "tw=90"
      "tx=90"
      "su=93"
      "sf=93"
      "xa=90"
      "sn=37"
      "sb=90"
      "df=90"
      "ds=90"
      "uu=37"
      "un=90"
      "uR=91"
      "gu=90"
      "gn=90"
      "gR=91"
      "lc=90"
      "lm=93"
      "da=90"
      "in=90"
      "bl=90"
      "hd=1;90"
      "cc=93"
      "xx=90"
      "ic=90"
      "ga=92"
      "gm=93"
      "gd=91"
      "gv=96"
      "gt=93"
      "gi=90"
      "gc=91"
      "Gm=97"
      "Go=90"
      "Gc=92"
      "Gd=93"
      "im=37"
      "vi=37"
      "mu=37"
      "lo=37"
      "cr=37"
      "do=37"
      "co=37"
      "tm=90"
      "cm=90"
      "bu=37"
      "sc=37"
    ];
  };
}
