{ pkgs, ... }: {
  users.users = {
    "user" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ home-manager ];
    };
  };
  home-manager.users."user" = import ../home;
}
