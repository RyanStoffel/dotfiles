{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/cmux/${file}";
in
{
  # Live symlink to the real file in the repo — edits apply after
  # `cmux reload-config`, no rebuild needed.
  #
  # cmux's own Settings UI writes this same file. Writes land in the repo, which
  # is the point; if a future cmux release starts replacing the file atomically
  # instead of writing in place, the symlink is what breaks, so check
  # `readlink ~/.config/cmux/cmux.json` if GUI changes stop showing up in git.
  #
  # Terminal colors are not set here. cmux embeds libghostty and reads
  # ~/.config/ghostty/config, so the palette lives in ghostty/config and this
  # file only covers cmux's own chrome: pane borders, sidebar, badges.
  home.file.".config/cmux/cmux.json".source = link "cmux.json";
}
