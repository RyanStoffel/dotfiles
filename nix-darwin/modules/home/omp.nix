{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/omp/${path}";
  # AGENTS.md / APPEND_SYSTEM.md / mcp.json are provider-agnostic — shared
  # with pi's copies instead of duplicating them.
  piLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/pi/${path}";
in
{
  # Declarative omp (oh-my-pi) config, live-symlinked into ~/.omp/agent.
  # Runtime state (auth.json/agent.db, sessions/, etc.) is left in place
  # and gitignored — never managed here.
  home.file.".omp/agent/config.yml".source = link "config.yml";
  home.file.".omp/agent/keybindings.json".source = link "keybindings.json";
  home.file.".omp/agent/AGENTS.md".source = piLink "AGENTS.md";
  home.file.".omp/agent/APPEND_SYSTEM.md".source = piLink "APPEND_SYSTEM.md";
  home.file.".omp/agent/mcp.json".source = piLink "mcp.json";
  home.file.".omp/agent/themes".source = link "themes";
}
