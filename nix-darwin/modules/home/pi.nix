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
  home.file.".config/pi/AGENTS.md".source = link "AGENTS.md";
  home.file.".config/pi/skills".source = link "skills";
  home.file.".config/pi/prompts".source = link "prompts";
}
