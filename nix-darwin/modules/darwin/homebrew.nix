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

      # browsers
      "helium-browser"
      "thebrowsercompany-dia"

      # utilities
      "alt-tab"
      "atoll"

      # media
      "spotify"
    ];

    brews = [
      "mas"
      "ollama"
      "opencode"
      "glab"
      "pi-coding-agent"
      "omp"
    ];

    masApps = {
      "Windows App" = 1295203466;
      "Xcode" = 497799835;
    };
  };
}
