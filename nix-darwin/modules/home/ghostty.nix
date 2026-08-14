{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty/${file}";
in
{
  # Live symlink to the real file in the repo — edits apply without a rebuild.
  home.file.".config/ghostty/config".source = link "config";
}
