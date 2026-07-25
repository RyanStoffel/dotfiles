{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  # Live symlink to the real file in the repo — edits apply without a rebuild.
  home.file.".config/ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty/config";
}
