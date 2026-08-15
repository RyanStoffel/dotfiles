{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [
      "FelixKratz/formulae"
      {
        name = "can1357/tap";
        trusted = true;
      }
    ];

    casks = [
      # launcher and productivity
      "raycast"

      # terminal
      "cmux"
      "font-jetbrains-mono-nerd-font"

      # dev
      "tailscale-app"
      "visual-studio-code"
      "claude"
      "claude-code"
      "github"
      "codex"
      "antigravity-cli"

      # latex
      "mactex-no-gui"
      "texifier"

      # browsers
      "thebrowsercompany-dia"

      # communication
      "zoom"
      "microsoft-teams"
      "slack"

      # notes
      "obsidian"
      "notion"

      # utilities
      "1password"
      "alt-tab"
      "atoll"
      "ryanstoffel/tap/caffeine"

      # media
      "spotify"
    ];

    brews = [
      "mas"
      "ollama"
      "glab"
      "omp"
      "tmux"
    ];

    masApps = {
      "Windows App" = 1295203466;
      "Xcode" = 497799835;
    };
  };
}
