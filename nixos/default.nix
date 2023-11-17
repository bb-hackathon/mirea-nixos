{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./ssh.nix
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

  system.stateVersion = "23.05";
}
