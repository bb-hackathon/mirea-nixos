{ pkgs, ... }: let
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
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      verbose = false;
      systemd.enable = true;
    };

    loader = {
      grub = {
        efiSupport = true;
        enable = true;
        device = drive.name;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    consoleLogLevel = 0;
  };

  nixpkgs.hostPlatform = "x86_64-linux";  
  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = [ "intel" ];
}
