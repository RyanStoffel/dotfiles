{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/herdr/${file}";
in
{
  # Live symlink to the real file in the repo — edits apply without a rebuild.
  home.file.".config/herdr/config.toml".source = link "config.toml";
  home.file.".local/bin/herdr-project".source = link "project-session.sh";
}
