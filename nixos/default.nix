{ pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    helix
    vim
    nushellFull
  ];

  system.stateVersion = "23.05";
}
