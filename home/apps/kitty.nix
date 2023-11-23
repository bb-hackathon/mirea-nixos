# INFO: Kitty: fast, feature-rich, GPU based terminal emulator

{ config, pkgs, ... }: let
  # Launch Kitty instead of xterm
  kitty-xterm = pkgs.writeShellScriptBin "xterm" /* shell */ ''
    ${config.programs.kitty.package}/bin/kitty -1 "$@"
  '';

  inherit (config.theme) colors;
in {
  home.packages = [ kitty-xterm ]; # The alias defined above
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      sync_to_monitor = "yes";
      window_padding_width = 4;
      single_window_margin_width = 4;

      # Opacity
      background_opacity = "0.9";

      # Colors
      foreground = "#${colors.text}";
      background = "#${colors.base}";

      # Black
      color0 = "#${colors.surface0}";
      color8 = "#${colors.surface1}";
      # Red
      color1 = "#${colors.red}";
      color9 = "#${colors.red}";
      # Green
      color2 = "#${colors.green}";
      color10 = "#${colors.green}";
      # Yellow
      color3 = "#${colors.yellow}";
      color11 = "#${colors.yellow}";
      # Blue
      color4 = "#${colors.blue}";
      color12 = "#${colors.blue}";
      # Magenta
      color5 = "#${colors.mauve}";
      color13 = "#${colors.mauve}";
      # Purple
      color6 = "#${colors.teal}";
      color14 = "#${colors.teal}";
      # White
      color7 = "#${colors.text}";
      color15 = "#${colors.text}";

      selection_background = "#${colors.text}";
      selection_foreground = "#${colors.base}";

      cursor = "#${colors.text}";
      cursor_shape = "beam";
      url_color = "#${colors.surface2}";

      active_border_color = "#${colors.surface1}";
      inactive_border_color = "#${colors.base}";
      active_tab_background = "#${colors.base}";
      active_tab_foreground = "#${colors.text}";
      inactive_tab_background = "#${colors.base}";
      inactive_tab_foreground = "#${colors.surface2}";
      tab_bar_background = "#${colors.base}";
    };
  };
}
