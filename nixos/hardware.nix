{ config, ... }: {
  # FStab
  fileSystems = {
    "/" = {
      device = "/dev/vda2";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "${config.boot.loader.efi.efiSysMountPoint}" = {
      device = "/dev/vda1";
      fsType = "vfat";
    };
  };

  # Bootloader & InitRD
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
      grub = {
        enable = true;
        device = "/dev/vda";
        useOSProber = true;
        forceInstall = true;
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";  
  networking.hostName = "mirea-nixos";
}
