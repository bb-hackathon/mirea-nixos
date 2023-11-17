{ inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users.users = {
    "user" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  home-manager.users."user" = import ../home;
}
