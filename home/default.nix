{ config, lib, pkgs, ... }: {
  imports = [
    ./hyprland.nix
  ]; # ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
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
}
