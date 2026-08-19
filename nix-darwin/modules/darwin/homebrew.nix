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
      {
        name = "ryanstoffel/tap";
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
      "zen"

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
      "gamehub"
    ];

    brews = [
      "mas"
      "ollama"
      "glab"
      "omp"
      "tmux"
      # Agent multiplexer. Homebrew tracks 0.8.0; nixpkgs still pins 0.7.1.
      "herdr"
    ];

    masApps = {
      "Windows App" = 1295203466;
      "Xcode" = 497799835;
    };
  };
}
