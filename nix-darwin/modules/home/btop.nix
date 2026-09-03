{ ... }:
{
  # btop ships saturated multi-hue gradients. This replaces them with the
  # crt-mono palette from ghostty/config: gray graphs that ramp to amber under
  # load, red only at the top of the temperature and CPU scales.
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "crt-mono";
      # Draw on the terminal's true black instead of btop's own background.
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      rounded_corners = false;
      # Braille glyphs read as a finer CRT trace than the default blocks.
      graph_symbol = "braille";
      show_battery = true;
      update_ms = 1000;
    };

    themes.crt-mono = ''
      theme[main_bg]="#000000"
      theme[main_fg]="#e4e4e4"
      theme[title]="#ffffff"
      theme[hi_fg]="#ffb000"
      theme[selected_bg]="#1c1c1c"
      theme[selected_fg]="#ffffff"
      theme[inactive_fg]="#4a4a4a"
      theme[graph_text]="#9a9a9a"
      theme[meter_bg]="#1c1c1c"
      theme[proc_misc]="#6f6f6f"
      theme[cpu_box]="#303030"
      theme[mem_box]="#303030"
      theme[net_box]="#303030"
      theme[proc_box]="#303030"
      theme[div_line]="#303030"
      theme[temp_start]="#6f6f6f"
      theme[temp_mid]="#ffb000"
      theme[temp_end]="#c94f42"
      theme[cpu_start]="#6f6f6f"
      theme[cpu_mid]="#b8b8b8"
      theme[cpu_end]="#ffb000"
      theme[free_start]="#303030"
      theme[free_mid]="#4a4a4a"
      theme[free_end]="#6f6f6f"
      theme[cached_start]="#4a4a4a"
      theme[cached_mid]="#6f6f6f"
      theme[cached_end]="#9a9a9a"
      theme[available_start]="#6f6f6f"
      theme[available_mid]="#9a9a9a"
      theme[available_end]="#b8b8b8"
      theme[used_start]="#9a9a9a"
      theme[used_mid]="#ffb000"
      theme[used_end]="#c94f42"
      theme[download_start]="#4a4a4a"
      theme[download_mid]="#9a9a9a"
      theme[download_end]="#e4e4e4"
      theme[upload_start]="#4a4a4a"
      theme[upload_mid]="#c98a2e"
      theme[upload_end]="#ffb000"
      theme[process_start]="#6f6f6f"
      theme[process_mid]="#b8b8b8"
      theme[process_end]="#ffb000"
    '';
  };
}
