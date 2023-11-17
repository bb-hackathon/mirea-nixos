{
  description = "NixOS flake for MIREA hackathon";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Declares a NixOS host
    mkNixOS = modules: nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = { inherit inputs outputs; };
    };

    # Declares a user@host
    mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
      inherit modules pkgs;
      extraSpecialArgs = { inherit inputs outputs; };
    };
  in {
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      mirea-nixos = mkNixOS [ ./nixos ];
    };

    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "user@mirea-nixos" = mkHome [ ./home ] nixpkgs.legacyPackages."x86_64-linux";
    };
  };
}
