{ outputs, config, lib, pkgs, ... }: {
  imports = [
    ./cli
    ./hyprland.nix
    ./helix.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  
  # Extra binary caches to avoid compiling from source
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
  };

  home = {
    username = lib.mkDefault "user";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "23.05";
  };

  theme = builtins.fromTOML (
    builtins.readFile ../themes/catppuccin-mocha.toml
  );
  
  # Store the userspace theme in `~/.config` in various formats
  xdg.configFile = {
    "theme.json".text = builtins.toJSON config.theme;
    "wallpapers/evening-sky.png".source = ../assets/evening-sky.png;
    "wallpapers/nix-black.png".source = ../assets/nix-black-4k.png;
    "wallpapers/nix-magenta-blue.png".source = ../assets/nix-magenta-blue-1920x1080.png;
    "wallpapers/nix-magenta-pink.png".source = ../assets/nix-magenta-pink-1920x1080.png;
  };
}
