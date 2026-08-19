{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/${file}";
in
{
  # Live symlinks to the real files in the repo — edits apply without a rebuild.
  home.file.".tmux.conf".source = link "tmux.conf";
  home.file.".config/tmux/tmux.conf".source = link "tmux.conf";
  home.file.".local/bin/tmux-dev".source = link "dev-session.sh";
  home.file.".local/bin/tmux-project".source = link "project-session.sh";
}
