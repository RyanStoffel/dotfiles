{ ... }:
{
  programs.btop = {
    enable = true;

    settings = {
      # Draw on the terminal's true black instead of btop's own background.
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      rounded_corners = false;
      # Braille glyphs read as a finer trace than the default blocks.
      graph_symbol = "braille";
      show_battery = true;
      update_ms = 1000;
    };
  };
}
