{ ... }: let
  drive = rec {
    name = "/dev/sda"; # !!!!!!!!!
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
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
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
