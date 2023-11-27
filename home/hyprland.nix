# INFO: Hyprland, the smooth Wayland compositor

{ inputs, config, pkgs, ... }: let
  inherit (config.theme) colors;
in {
  imports = [
    ./apps/kitty.nix
    inputs.hyprland.homeManagerModules.default
  ];

  # Extra binary caches to avoid compiling from source
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  services.avizo.enable = true;
  home.packages = with pkgs; [
    swww
    grimblast
    alsaUtils
    brillo
    gtk-engine-murrine
    gnome.adwaita-icon-theme
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = /* awk */ ''
      # Environment variables
      env = SWWW_TRANSITION_DURATION, 2
      env = SWWW_TRANSITION_FPS, 60
      env = SWWW_TRANSITION, center

      # Monitor
      monitor = , 1920x1080, auto, 1
      
      # Autostart
      exec-once = ${pkgs.swww}/bin/swww init
      exec-once = ${pkgs.avizo}/bin/avizo-service
      exec-once = waybar

      # Uncomment one line to set the wallpapers (these 4 are always provided)
      exec = sleep 0.5 && ${pkgs.swww}/bin/swww img ~/.config/wallpapers/evening-sky.png
      # exec = sleep 0.5 && ${pkgs.swww}/bin/swww img ~/.config/wallpapers/nix-black.png
      # exec = sleep 0.5 && ${pkgs.swww}/bin/swww img ~/.config/wallpapers/nix-magenta-blue.png
      # exec = sleep 0.5 && ${pkgs.swww}/bin/swww img ~/.config/wallpapers/nix-magenta-pink.png

      # Kill window | Exit or reload hyprland | Lock screen
      bind = SUPER      SHIFT, Q, killactive,
      bind = SUPER CTRL SHIFT, Q, exec, kill -9 $(hyprctl activewindow -j | jq '.pid')
      bind = SUPER      SHIFT, R, exec, hyprctl reload
      bind = SUPER CTRL SHIFT, L, exec, gtklock
      bind = SUPER CTRL SHIFT, E, exit

      # Screenshots
      bind = ,        PRINT, exec, ${pkgs.grimblast}/bin/grimblast copysave output
      bind = SUPER SHIFT, S, exec, ${pkgs.grimblast}/bin/grimblast copysave area

      # Shift focus
      bind = SUPER, H, movefocus, l
      bind = SUPER, J, movefocus, d
      bind = SUPER, K, movefocus, u
      bind = SUPER, L, movefocus, r

      # Move windows within layout
      bind = SUPER SHIFT, H, movewindow, l
      bind = SUPER SHIFT, J, movewindow, d
      bind = SUPER SHIFT, K, movewindow, u
      bind = SUPER SHIFT, L, movewindow, r

      # Float | fullscreen
      bind = SUPER, T, togglefloating,
      bind = SUPER, F, fullscreen,

      # Main apps
      bind = SUPER, RETURN, exec, ${pkgs.kitty}/bin/kitty
      bind = SUPER, P,      exec, ${pkgs.kitty}/bin/kitty ${pkgs.bottom}/bin/btm --battery

      # Workspace switching
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      # Move focused window to workspace
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      # Workspace-assigned apps
      bind = CTRL SHIFT, 1, exec, ${pkgs.kitty}/bin/kitty

      # Brightness
      bind = , XF86MonBrightnessUp,   exec, ${pkgs.brillo}/bin/brillo -q -A 10 -u 100000
      bind = , XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 10 -u 100000

      # Volume
      bind = SUPER SHIFT, M,         exec, volumectl toggle-mute
      bind = , XF86AudioMute,        exec, volumectl toggle-mute
      bind = , XF86AudioMicMute,     exec, volumectl -m toggle-mute
      bind = , XF86AudioRaiseVolume, exec, volumectl -u up
      bind = , XF86AudioLowerVolume, exec, volumectl -u down

      # Power button
      bind = , XF86PowerOff, exec, hyprlock.sh

      # Laptop lid
      bindl = , switch:on:Lid Switch, exec, hyprlock.sh
      bindl = , switch:off:Lid Switch, dpms, on

      # Move & resize floating windows
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Mouse
      input {
        follow_mouse = 1
        sensitivity = 0.4
        touchpad {
          natural_scroll = no
        }

        # Keyboard
        kb_layout = us, ru
        kb_options = grp:win_space_toggle
      }

      decoration {
        rounding = 8
        drop_shadow = true
        shadow_range = 16
        col.shadow = rgb(${colors.base})

        dim_inactive = false
        dim_strength = 0.3

        blur {
          size = 4
          passes = 3
          brightness = 1
          contrast = 1
        }
      }

      general {
        # Layout
        layout = dwindle
        gaps_in = 8
        gaps_out = 16
        border_size = 2

        col.active_border = rgb(${colors.mauve})
        col.inactive_border = rgb(${colors.base})

        # Mouse & cursor
        apply_sens_to_raw = 1
        cursor_inactive_timeout = 5
        no_cursor_warps = true
      }

      # Master layout
      master {
        special_scale_factor = 0.8
        new_is_master        = false
        new_on_top           = false
        no_gaps_when_only    = false
      }

      # Dwindle layout
      dwindle {
        force_split = 2
      }

      misc {
        # Built-in wallpaper things
        disable_hyprland_logo = true
        disable_splash_rendering = true

        vfr = true # Variable framerate
        mouse_move_enables_dpms = true
        key_press_enables_dpms = true
      }

      # Fix HiDPI XWayland
      xwayland {
        force_zero_scaling = true
      }
      env = GDK_SCALE, 2
      # env = GDK_DPI_SCALE, 2

      # GTK file dialogs
      windowrulev2 = float, title:^(Open.*)$
      
      # Custom bezier curves
      bezier = cubic, 0.65, 0, 0.35, 1
      bezier = sine, 0.37, 0, 0.63, 1
      bezier = quad, 0.45, 0, 0.55, 1
      bezier = expo, 0.22, 1, 0.36, 1

      animations {
        enabled = 1
        # --        <name>       <on/off> <time> <bezier> <style>
        animation = windowsIn,   1,       3,     expo,    slide
        animation = windowsOut,  1,       3,     expo,    slide
        animation = windowsMove, 1,       3,     expo
        animation = fade,        1,       3,     expo
        animation = fadeOut,     1,       3,     expo
        animation = workspaces,  1,       4,     expo,    slide
        animation = border,      1,       8,     default
      }
    '';
  };

  programs.waybar = {
    enable = true;
    style = /* css */ ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 16px;
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: #${colors.text};
      }

      #window,
      #clock,
      #network,
      #idle_inhibitor,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #battery,
      #tray,
      #custom-lock {
        background-color: #${colors.base};
        padding: 0.5rem 0.75rem;
        margin: 16px 0;
      }

      #workspaces {
        border-radius: 1rem 0px 0px 1rem;
        margin: 16px 0 16px 16px;
        padding-left: 0.3rem;
        background-color: #${colors.base};
      }

      #workspaces button {
        color: #${colors.lavender};
        background-color: transparent;
        border-radius: 2rem;
        padding: 0.25rem;
        margin: 0.3rem 0;
        transition: color 0.5s, background-color 0.5s;
      }

      #workspaces button.empty {
        color: #${colors.overlay0};
      }

      #workspaces button.special {
        color: #${colors.rosewater};
      }

      #workspaces button.active {
        color: #${colors.sky};
        background-color: #${colors.surface1};
      }

      #workspaces button:hover {
        color: #${colors.sapphire};
        background-color: #${colors.surface2};
      }

      #window {
        border-radius: 0px 1rem 1rem 0px;
        background-color: #${colors.base};
        margin-right: 1rem;
      }

      #clock {
        border-radius: 1rem;
        color: #${colors.blue};
      }

      #network {
        color: #${colors.teal};
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #idle_inhibitor.deactivated {
        color: #${colors.peach};
      }

      #idle_inhibitor.activated {
        color: #${colors.green};
      }

      #cpu {
        color: #${colors.mauve};
      }

      #memory {
        margin-left: 1rem;
        margin-right: 1rem;
        border-radius: 1rem;
        color: #${colors.peach};
      }

      #temperature {
        color: #${colors.flamingo};
      }

      #backlight {
        margin-left: 1rem;
        margin-right: 1rem;
        border-radius: 1rem;
        color: #${colors.yellow};
      }

      #battery {
        margin-left: 1rem;
        margin-right: 1rem;
        border-radius: 1rem;
        color: #${colors.green};
      }

      #battery.charging {
        color: #${colors.green};
      }

      #battery.warning:not(.charging) {
        color: #${colors.red};
      }

      #tray {
        margin-right: 0.75rem;
        border-radius: 1rem;
      }

      #custom-lock {
        border-radius: 1rem;
        margin: 16px;
        color: #${colors.lavender};
      }
    '';
  };

  xdg.configFile."waybar/config".text = /* json */ ''
    {
      "layer": "top",
      "position": "top",

      "modules-left": ["hyprland/workspaces", "hyprland/window"],

      "hyprland/workspaces": {
        "sort-by-name": true,
        "format": "{id}",
        "show-special": true,
        "persistent_workspaces": {
          "*": 10
        }
       },

      "modules-center": ["clock"],

      "clock": {
        "interval": 1,
        "format": " {:%H:%M:%S %d %b}",
        "tooltip-format": "<tt><small>{calendar}</small></tt>",
        "calendar": {
          "mode"          : "year",
          "mode-mon-col"  : 3,
          "weeks-pos"     : "right",
          "on-scroll"     : 1,
          "on-click-right": "mode",
          "format": {
            "months":   "<span color='#${colors.maroon}'><b>{}</b></span>",
            "days":     "<span color='#${colors.text}'><b>{}</b></span>",
            "weeks":    "<span color='#${colors.surface2}'><b>{}</b></span>",
            "weekdays": "<span color='#${colors.mauve}'><b>{}</b></span>",
            "today":    "<span color='#${colors.mauve}'><b><u>{}</u></b></span>"
          }
        }
      },

      "modules-right": [
        "network",
        "idle_inhibitor",
        "cpu",
        "memory",
        "temperature",
        "backlight",
        "battery",
        "tray",
        "custom/lock",
      ],

      "network": {
        "format-wifi": "{essid} ({signalStrength}%) 󰖩",
        "tooltip-format-wifi": "{ifname}: {ipaddr}/{cidr}\n{essid} on {frequency}GHz",
        "format-ethernet": "{ipaddr} 󰈁",
        "tooltip-format": "{ifname}: {ipaddr}/{cidr}",
        "format-linked": "{ifname} (No IP) 󰌷",
        "format-disconnected": "Disconnected 󰈂",
      },

      "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
          "activated": "",
          "deactivated": ""
        }
      },

      "cpu": {
        "interval": 10,
        "format": "{usage}% ",
        "on-click": "kitty htop"
      },

      "memory": {
        "interval": 10,
        "format": "{}% ",
        "on-click": "kitty htop"
      },

      "temperature": {
        "interval": 30,
        "critical-threshold": 80,
        "format": "{temperatureC}°C ",
        "on-click": "kitty htop"
      },

      "backlight": {
        "format": "{percent}% {icon}",
        "format-icons": ["", "", "", "", "", "", "", "", ""]
      },

      "battery": {
        "interval": 60,
        "full-at": 95,
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-charging": "{capacity}% 󰂄",
        "format-plugged": "{capacity}% ",
        "format-icons": ["󱃍", "󱃍", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹"],
        "tooltip-format": "{capacity}%\n{timeTo}\n{power} W"
      },

      "tray": {
        "icon-size": 15,
        "spacing": 10
      },

      "custom/lock": {
        "tooltip": false,
        "on-click": "gtklock",
        "format": ""
      },
    }
  '';

  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "mocha";
        tweaks = [];
      };
    };
  };
}
