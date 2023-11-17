{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/vda2";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/vda1";
      fsType = "vfat";
    };
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
    
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_blk"
      ];
      kernelModules = [];
    };

    loader = {
      # grub = {
      #   enable = true;
      #   device = "nodev";
      #   efiSupport = true;
      #   efiInstallAsRemovable = true;
      # };
      efi.efiSysMountPoint = "/boot";
      systemd-boot.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";  
}
