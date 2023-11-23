# INFO: Hyprland, the smooth Wayland compositor

{ inputs, pkgs, ... }: {
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

  home.packages = with pkgs; [
    avizo
    swww
    grimblast
    alsaUtils
    brillo
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = /* awk */ ''
      # Autostart
      exec-once = ${pkgs.swww}/bin/swww init
      exec-once = ${pkgs.eww-wayland}/bin/eww daemon --restart --force-wayland # TODO
      exec-once = ${pkgs.avizo}/bin/avizo-service
      exec = sleep 0.5 && ${pkgs.swww}/bin/swww clear 1e1e2e

      # Kill window | Exit or reload hyprland | Lock screen
      bind =      ALT SHIFT,      Q, killactive,
      bind =      ALT CTRL SHIFT, Q, exec, kill -9 $(hyprctl activewindow -j | jq '.pid')
      bind =      ALT SHIFT, R, exec, hyprctl reload && eww reload

      # Screenshots
      bind = , PRINT,      exec, ${pkgs.grimblast}/bin/grimblast copysave output
      bind = ALT SHIFT, S, exec, ${pkgs.grimblast}/bin/grimblast copysave area

      # Shift focus
      bind = ALT, H, movefocus, l
      bind = ALT, J, movefocus, d
      bind = ALT, K, movefocus, u
      bind = ALT, L, movefocus, r

      # Move windows within layout
      bind = ALT SHIFT, H, movewindow, l
      bind = ALT SHIFT, J, movewindow, d
      bind = ALT SHIFT, K, movewindow, u
      bind = ALT SHIFT, L, movewindow, r

      # Float | fullscreen
      bind = ALT, T, togglefloating,
      bind = ALT, F, fullscreen,

      # Main apps
      bind = ALT,       RETURN, exec, ${pkgs.kitty}/bin/kitty
      bind = ALT,       P,      exec, ${pkgs.kitty}/bin/kitty ${pkgs.bottom}/bin/btm --battery

      # Workspace switching
      bind = ALT, 1, workspace, 1
      bind = ALT, 2, workspace, 2
      bind = ALT, 3, workspace, 3
      bind = ALT, 4, workspace, 4
      bind = ALT, 5, workspace, 5
      bind = ALT, 6, workspace, 6
      bind = ALT, 7, workspace, 7
      bind = ALT, 8, workspace, 8
      bind = ALT, 9, workspace, 9
      bind = ALT, 0, workspace, 10

      # Move focused window to workspace
      bind = ALT SHIFT, 1, movetoworkspace, 1
      bind = ALT SHIFT, 2, movetoworkspace, 2
      bind = ALT SHIFT, 3, movetoworkspace, 3
      bind = ALT SHIFT, 4, movetoworkspace, 4
      bind = ALT SHIFT, 5, movetoworkspace, 5
      bind = ALT SHIFT, 6, movetoworkspace, 6
      bind = ALT SHIFT, 7, movetoworkspace, 7
      bind = ALT SHIFT, 8, movetoworkspace, 8
      bind = ALT SHIFT, 9, movetoworkspace, 9
      bind = ALT SHIFT, 0, movetoworkspace, 10

      # Workspace-assigned apps
      bind = CTRL SHIFT, 1, exec, ${pkgs.kitty}/bin/kitty

      # Brightness
      bind = , XF86MonBrightnessUp,   exec, ${pkgs.brillo}/bin/brillo -q -A 10 -u 100000
      bind = , XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 10 -u 100000

      # Volume
      bind = ALT SHIFT, M,            exec, volumectl toggle-mute
      bind = , XF86AudioMute,         exec, volumectl toggle-mute
      bind = , XF86AudioMicMute,      exec, volumectl -m toggle-mute
      bind = , XF86AudioRaiseVolume,  exec, volumectl -u up
      bind = , XF86AudioLowerVolume,  exec, volumectl -u down

      # Power button
      bind = , XF86PowerOff, exec, hyprlock.sh

      # Laptop lid
      bindl = , switch:on:Lid Switch, exec, hyprlock.sh
      bindl = , switch:off:Lid Switch, dpms, on

      # Move & resize floating windows
      bindm = ALT, mouse:272, movewindow
      bindm = ALT, mouse:273, resizewindow

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
        col.shadow = rgb(000000)

        dim_inactive = true
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

        col.active_border = rgb(cba6f7)
        col.inactive_border = rgb(313244)

        # Mouse & cursor
        apply_sens_to_raw = 1
        cursor_inactive_timeout = 5
        no_cursor_warps = true
      }

      # Master layout
      master {
        special_scale_factor =  0.8
        new_is_master =         false
        new_on_top =            false
        no_gaps_when_only =     false
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
    '';
  };
}
