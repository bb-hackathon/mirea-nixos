{ ... }: {
  users.users = {
    "user" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
