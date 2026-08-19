{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zellij/${file}";
in
{
  # Live symlinks to the real files in the repo — edits apply without a rebuild.
  home.file.".config/zellij/config.kdl".source = link "config.kdl";
  home.file.".config/zellij/layouts/dev.kdl".source = link "layouts/dev.kdl";
}
