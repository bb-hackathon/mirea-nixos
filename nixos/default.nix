{ inputs, outputs, config, lib, pkgs, ... }: let
  inherit (config.theme) colors;
in {
  imports = [
    ./hardware.nix
    ./ssh.nix
    ./user.nix
    ./hyprland.nix # Enable system-wide Hyprland
    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    helix
    vim
    neovim
    nushellFull
    rustup
    gcc
    gnumake
    gtklock
    catppuccin-sddm-corners
    librewolf
    alsaUtils
  ] ++ (with pkgs.libsForQt5.qt5; [
    # For SDDM's `catppuccin` theme
    qtbase
    qtgraphicaleffects
    qtsvg
    qtquickcontrols2
  ]);

  # Nix settings
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];

      # Extra binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        # "Iosevka"
      ];
    })
  ];

  home-manager.extraSpecialArgs = { 
    inherit inputs outputs;
  };

  system.stateVersion = "23.05";
  security.pam.services.gtklock = {};
  networking = {
    hostName = "mirea-nixos";
    networkmanager.enable = true;
  };

  console = {
    earlySetup = true;
    colors = [
      # Normal
      "${colors.base}"
      "${colors.red}"
      "${colors.green}"
      "${colors.yellow}"
      "${colors.blue}"
      "${colors.mauve}"
      "${colors.teal}"
      "${colors.text}"
      # Bright
      "${colors.surface0}"
      "${colors.red}"
      "${colors.green}"
      "${colors.yellow}"
      "${colors.blue}"
      "${colors.mauve}"
      "${colors.teal}"
      "${colors.text}"
    ];
  };

  # SDDM
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-sddm-corners";
    };
  };

  # PipeWire
  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # CUPS
  services.printing.enable = true;

  # Locale
  i18n = with lib; {
    defaultLocale = mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE          = mkDefault "en_US.UTF-8";
      LC_NUMERIC        = mkDefault "en_US.UTF-8";
      LC_TIME           = mkDefault "en_US.UTF-8";
      LC_COLLATE        = mkDefault "en_US.UTF-8";
      LC_MONETARY       = mkDefault "en_US.UTF-8";
      LC_MESSAGES       = mkDefault "en_US.UTF-8";
      LC_PAPER          = mkDefault "en_US.UTF-8";
      LC_NAME           = mkDefault "en_US.UTF-8";
      LC_ADDRESS        = mkDefault "en_US.UTF-8";
      LC_TELEPHONE      = mkDefault "en_US.UTF-8";
      LC_MEASUREMENT    = mkDefault "en_US.UTF-8";
      LC_IDENTIFICATION = mkDefault "en_US.UTF-8";
    };
    supportedLocales = mkDefault [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  # Timezone
  time.timeZone = lib.mkDefault "Europe/Moscow";

  theme = builtins.fromTOML (
    builtins.readFile ../themes/catppuccin-mocha.toml
  );
}
