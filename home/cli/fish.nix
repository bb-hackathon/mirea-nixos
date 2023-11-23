# INFO: `fish`, the friendly interactive shell
{ config, lib, ... }: let
  # inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  inherit (config.theme) colors;
in {
  programs.fish = {
    enable = true; # ISSUE: users.users.*.shell complains for some reason
    
    interactiveShellInit = /* fish */ ''
      fish_add_path ~/.cargo/bin

      set LS_COLORS $(vivid generate catppuccin-mocha)
      set fish_color_autosuggestion 'brblack'
      set fish_color_cancel -r
      set fish_color_command green
      set fish_color_comment red
      set fish_color_cwd green
      set fish_color_cwd_root red
      set fish_color_end green
      set fish_color_error brred
      set fish_color_escape brcyan
      set fish_color_history_current --bold
      set fish_color_host normal
      set fish_color_host_remote yellow
      set fish_color_normal normal
      set fish_color_operator brcyan
      set fish_color_param blue
      set fish_color_quote yellow
      set fish_color_redirection 'cyan'  '--bold'
      set fish_color_search_match 'bryellow'  '--background=brblack'
      set fish_color_selection 'white'  '--bold'  '--background=brblack'
      set fish_color_status red
      set fish_color_user brgreen
      set fish_color_valid_path --underline
      set fish_pager_color_completion normal
      set fish_pager_color_description 'B3A06D'  'yellow'  '-i'
      set fish_pager_color_prefix 'normal'  '--bold'  '--underline'
      set fish_pager_color_progress 'brwhite'  '--background=cyan'
      set fish_pager_color_selected_background -r
      set PALETTE "${lib.concatStringsSep "," [
        "${colors.crust}"
        "${colors.mantle}"
        "${colors.base}"
        "${colors.surface0}"
        "${colors.surface1}"
        "${colors.surface2}"
        "${colors.text}"
        "${colors.red}"
        "${colors.maroon}"
        "${colors.peach}"
        "${colors.yellow}"
        "${colors.green}"
        "${colors.teal}"
        "${colors.sky}"
        "${colors.blue}"
        "${colors.mauve}"
        "${colors.pink}"
      ]}"

      # `anywhere` abbreviations
      abbr --add --position anywhere -- "rd" "rmdir"
      abbr --add --position anywhere -- "md" "mkdir -pv"
      abbr --add --position anywhere -- "cat" "bat"
      abbr --add --position anywhere -- "scl" "systemctl"
      abbr --add --position anywhere -- R "| rg"
      abbr --add --position anywhere L --set-cursor "% | less"

      function last_history_item
        echo $history[1]
      end

      abbr --add !! --position anywhere --function last_history_item
    '';

    shellAbbrs = {
      # Common commands & tools
      s = "sudo";
      free = "free -h --si";
      duf = "duf -theme ansi";
      btm = "btm --battery";
      z = "zellij";
      zl = "zellij --layout";

      # Power
      poweroff = "systemctl poweroff";
      shutdown = "systemctl poweroff";
      reboot = "systemctl reboot";

      # Erdtree
      ls = "erdtree --level 1";
      lsa = "erdtree --hidden --level 1";
      tree = "erdtree";
      atree = "erdtree --hidden --no-git";
      sz = "erdsize --hidden --level 1";

      # Git: Common
      g = "git";
      ga = "git add";
      gst = "git status";
      grs = "git restore";
      grst = "git restore --staged";
      gd = "git diff";
      gds = "git diff --staged";
      glg = "git log";
      # Git: Commits
      gc = "git commit --verbose --edit";
      gcmsg = "git commit --message";
      # Git: Remotes & stash
      gp = "git push";
      gpa = "git push --all";
      gl = "git pull";
      gla = "git pull --all";
      gsta = "git stash";
      gstaa = "git stash apply";
      gstac = "git stash clear";
      gstal = "git stash list";

      # Nix, NixOS & Home-manager
      n = "nix";
      ns = "nix shell";
      nr = "nix run";
      nf = "nix flake";
      nfi = "nix flake init";
      nfu = "nix flake update";
      nfc = "nix flake check";
      nfl = "nix flake lock";
      nd = "nix develop";
      nst = "nix store";
      nsto = "nix store optimise";
      hm = "home-manager";

      # Desktops
      Hyprland = "dbus-run-session Hyprland";
      hcl = "hyprctl";

      # Other CTL's
      jcl = "journalctl";
    };

    # Aliases expand after abbreviations do, so they can be used to
    # silently enable stuff for certain commands, for example, exa:
    shellAliases = {
      # exa = "exa --icons --sort=type";
      erd = "erd --layout inverted --human --icons --truncate --dir-order last";
      erdtree = "echo && erd --suppress-size --follow";
      erdsize = "echo && erd --no-ignore";
      ip = "ip --color";
    };

    functions = {
      # Silent startup (disable greeting)
      fish_greeting = "";
    };
  };
}
