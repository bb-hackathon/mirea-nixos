{ inputs, outputs, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./ssh.nix
    ./user.nix
    ./hyprland.nix # Enable system-wide Hyprland
    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    helix
    vim
    nushellFull
  ];

  # Nix settings
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];

      # Extra binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        # "Iosevka"
      ];
    })
  ];

  home-manager.extraSpecialArgs = { 
    inherit inputs outputs;
  };

  system.stateVersion = "23.05";
  networking.hostName = "mirea-nixos";

  theme = builtins.fromTOML (
    builtins.readFile ../themes/catppuccin-mocha.toml
  );
}
