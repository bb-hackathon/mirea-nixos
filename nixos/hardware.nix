{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "btrfs";
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";  
}
