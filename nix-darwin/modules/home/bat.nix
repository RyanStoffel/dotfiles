{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  # bat owns the apple-terminal syntax theme, and through bat's theme cache
  # delta renders diffs with it too (see git.nix).
  programs.bat = {
    enable = true;
    config = {
      theme = "apple-terminal";
      style = "numbers,changes";
    };
  };

  # The theme is linked live rather than passed to programs.bat.themes, because
  # that option copies a build-time path and the flake root is nix-darwin/, so
  # anything above it is outside the flake source tree.
  #
  # home-manager's own batCache activation step runs `bat cache --build` after
  # linking, which is what registers the theme. Editing the tmTheme afterwards
  # needs a manual `bat cache --build` to take effect.
  home.file.".config/bat/themes/apple-terminal.tmTheme".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/bat/themes/apple-terminal.tmTheme";
}
