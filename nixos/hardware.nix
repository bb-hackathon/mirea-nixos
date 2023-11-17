{ config, ... }: {
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
        efiSupport = true;
        # efiInstallAsRemovable = true;
        useOSProber = true;
        forceInstall = true;
      };
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";  
}
