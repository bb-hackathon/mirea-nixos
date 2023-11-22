# C.A.V.A
{ config, pkgs, ... }: let
  inherit (config.theme) colors;
in {
  home.packages = with pkgs; [ cava ];
  xdg.configFile."cava/config".text = /* toml */ ''
    [color]
    gradient = 1
    gradient_color_1 = '#${colors.teal}'
    gradient_color_2 = '#${colors.sky}'
    gradient_color_3 = '#${colors.sapphire}'
    gradient_color_4 = '#${colors.blue}'
    gradient_color_5 = '#${colors.mauve}'
    gradient_color_6 = '#${colors.pink}'
    gradient_color_7 = '#${colors.maroon}'
    gradient_color_8 = '#${colors.red}'
  '';
}
