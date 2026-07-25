{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [
      "FelixKratz/formulae"
    ];

    casks = [
      # launcher and productivity
      "raycast"

      # terminal
      "ghostty"
      "cmux"

      # dev
      "tailscale-app"
      "visual-studio-code"
      "zed"
      "claude"
      "claude-code"
      "codex"
      "github"
      "google-gemini"
      "t3-code@nightly"
      "antigravity-cli"
      "github-copilot-app"
      "linear"

      # capture
      "cleanshot"

      # monitoring
      "stats"

      # browsers
      "helium-browser"

      # utilities
      "the-unarchiver"
      "appcleaner"
      "keka"
      "rectangle"
      "alt-tab"
    ];

    brews = [
      "mas"
      "ollama"
      "opencode"
      "glab"
      "pi-coding-agent"
    ];

    masApps = {
      "Windows App" = 1295203466;
      "Xcode"       = 497799835;
    };
  };
  system.activationScripts.postActivation.text = ''
    echo "Installing opencode-with-claude via user npm..."
    sudo -H -u ryanstoffel bash -c '
      export HOME=/Users/ryanstoffel
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export PATH="${pkgs.nodejs}/bin:$PATH"
      mkdir -p "$NPM_CONFIG_PREFIX"
      ${pkgs.nodejs}/bin/npm install -g opencode-with-claude
    '
  '';
}
