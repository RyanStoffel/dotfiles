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
      "hermes-desktop"

      # latex
      "mactex-no-gui"

      # browsers
      "zen"

      # communication
      "zoom"
      "microsoft-teams"
      "slack"
      "vesktop"

      # notes
      "obsidian"
      "notion"

      # utilities
      "1password"
      "alt-tab"
      "atoll"
      "ryanstoffel/tap/caffeine"
      "ryanstoffel/tap/tidy"

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
      "herdr"
      "hermes-agent"
    ];

    masApps = {
      "Windows App" = 1295203466;
      "Xcode" = 497799835;
    };
  };
}
