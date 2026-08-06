{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/pi/${path}";
in
{
  # Declarative pi config, live-symlinked into ~/.config/pi (= ~/.pi/agent).
  # Runtime state (auth.json, sessions/, models-store.json, npm/) is left in place
  # and gitignored — never managed here.
  home.file.".config/pi/settings.json".source = link "settings.json";
  home.file.".config/pi/keybindings.json".source = link "keybindings.json";
  home.file.".config/pi/AGENTS.md".source = link "AGENTS.md";
  home.file.".config/pi/APPEND_SYSTEM.md".source = link "APPEND_SYSTEM.md";
  home.file.".config/pi/mcp.json".source = link "mcp.json";
  home.file.".config/pi/skills".source = link "skills";
  home.file.".config/pi/prompts".source = link "prompts";
  home.file.".config/pi/themes".source = link "themes";
  home.file.".config/pi/extensions".source = link "extensions";
  home.file.".config/pi/node_modules".source = link "node_modules";
}
