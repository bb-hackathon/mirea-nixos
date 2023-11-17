{ ... }: let
  drive = rec {
    name = "/dev/vda"; # !!!!!!!!!
    part = "${name}";
  };
in {
  # FStab
  fileSystems = {
    "/" = {
      device = "${drive.part}2";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "${drive.part}1";
      fsType = "vfat";
    };
  };

  # Bootloader & InitRD
  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
    
    initrd = {
      availableKernelModules = [
        # !!!!!!!!!!!!!
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_blk"
        # !!!!!!!!!!!!!
      ];
      kernelModules = [];
    };

    loader = {
      grub = {
        enable = true;
        device = drive.name;
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";  
}
