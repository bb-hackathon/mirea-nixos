# INFO: Hyprland, the smooth Wayland compositor

{ inputs, pkgs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ];

  # Extra binary caches to avoid compiling from source
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = /* ini */ ''
      bind = SUPER, RETURN, exec, ${pkgs.kitty}/bin/kitty # Open a terminal
    '';
  };
}