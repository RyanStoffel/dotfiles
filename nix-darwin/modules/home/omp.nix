{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/omp/${path}";
in
{
  # Declarative omp (oh-my-pi) config, live-symlinked into ~/.omp/agent.
  # Runtime state (auth.json/agent.db, sessions/, etc.) is left in place
  # and gitignored — never managed here.
  home.file.".omp/agent/config.yml".source = link "config.yml";
  home.file.".omp/agent/keybindings.json".source = link "keybindings.json";
  home.file.".omp/agent/AGENTS.md".source = link "AGENTS.md";
  home.file.".omp/agent/themes".source = link "themes";
  home.file.".omp/agent/skills".source = link "skills";
}
