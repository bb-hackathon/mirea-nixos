{ config, pkgs, ... }: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users = {
    "user" = {
      isNormalUser = true;
      initialPassword = "12345";
      packages = with pkgs; [ home-manager ];
      shell = pkgs.fish; # See below!
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "input"
      ] ++ ifTheyExist [
        "networkmanager"
        "docker"
        "git"
        "libvirtd"
      ];
    };
    "root".initialPassword = "12345";
  };

  home-manager.users."user" = import ../home;

  # A friendly interactive shell (an alternative to bash)
  programs.fish.enable = true;
}
