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
      # Flakes support
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };

  home-manager.extraSpecialArgs = { 
    inherit inputs outputs;
  };

  system.stateVersion = "23.05";
  networking.hostName = "mirea-nixos";

  theme = builtins.fromTOML (
    builtins.readFile ../themes/catppuccin-mocha.toml
  );
}
