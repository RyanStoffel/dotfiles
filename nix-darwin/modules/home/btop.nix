{ ... }:
{
  # btop ships saturated multi-hue gradients. This replaces them with the
  # apple-terminal palette from ghostty/config: gray graphs that ramp to yellow
  # under load, red only at the top of the temperature and memory scales.
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "apple-terminal";
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

    themes.apple-terminal = ''
      theme[main_bg]="#000000"
      theme[main_fg]="#e0e0e0"
      theme[title]="#e5eff5"
      theme[hi_fg]="#e5c872"
      theme[selected_bg]="#273d4c"
      theme[selected_fg]="#e5eff5"
      theme[inactive_fg]="#465c6d"
      theme[graph_text]="#a9b5bf"
      theme[meter_bg]="#273d4c"
      theme[proc_misc]="#7b8c99"
      theme[cpu_box]="#35424c"
      theme[mem_box]="#35424c"
      theme[net_box]="#35424c"
      theme[proc_box]="#35424c"
      theme[div_line]="#35424c"
      theme[temp_start]="#7b8c99"
      theme[temp_mid]="#c4ac62"
      theme[temp_end]="#b45648"
      theme[cpu_start]="#7b8c99"
      theme[cpu_mid]="#dee5eb"
      theme[cpu_end]="#e5c872"
      theme[free_start]="#35424c"
      theme[free_mid]="#465c6d"
      theme[free_end]="#7b8c99"
      theme[cached_start]="#465c6d"
      theme[cached_mid]="#7b8c99"
      theme[cached_end]="#a9b5bf"
      theme[available_start]="#7b8c99"
      theme[available_mid]="#a9b5bf"
      theme[available_end]="#dee5eb"
      theme[used_start]="#a9b5bf"
      theme[used_mid]="#c4ac62"
      theme[used_end]="#b45648"
      theme[download_start]="#465c6d"
      theme[download_mid]="#a9b5bf"
      theme[download_end]="#e0e0e0"
      theme[upload_start]="#465c6d"
      theme[upload_mid]="#c4ac62"
      theme[upload_end]="#e5c872"
      theme[process_start]="#7b8c99"
      theme[process_mid]="#dee5eb"
      theme[process_end]="#e5c872"
    '';
  };
}
