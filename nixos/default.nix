{ inputs, outputs, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./ssh.nix
    ./user.nix
  ];

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
}
