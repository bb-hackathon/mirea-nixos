# INFO: `starship.rs`, rust-powered, cross-platform shell propmt
{ config, lib, ... }: let
  inherit (config.theme) colors;
in {
  programs.starship = {
    enable = true;
    enableNushellIntegration = false;
    settings = {
      scan_timeout = 10;
      add_newline = false;

      format = lib.concatStrings [
        " "
        "$directory"
        "$git_branch"
        "$battery"
        # "$package"
        "$line_break"
        "$hostname"
        "$cmd_duration"
        "$character"
      ];

      directory = {
        style = "fg:bold blue";
        format = lib.concatStrings [
          "[$read_only]($read_only_style)"
          "[󰉋 $path ]($style)"
        ];
        repo_root_style = "bold purple";
        repo_root_format = lib.concatStrings [
          "[󰉋 $repo_root]($repo_root_style)"
          "[$path ]($style)"
        ];
        read_only = "RO ";
        read_only_style = "bold yellow";
        truncation_length = 3;
      };

      git_branch = {
        style = "bold red";
        format = lib.concatStrings [
          "[$symbol $branch(:$remote_branch) ]($style)"
        ];
        symbol = "󰊢";
      };

      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
          {
            threshold = 30;
            style = "bold yellow";
          }
          {
            threshold = 100;
            style = "bold white";
          }
        ];
      };

      hostname = let
        bg = "cyan";
        fg = "black";
      in {
        style = "italic bold fg:${fg} bg:${bg}";
        format = lib.concatStrings [
          "[](fg:${bg})"
          "[$ssh_symbol]($style)"
          "[$hostname]($style)"
          "[ ](fg:${bg} bg:${fg})"
        ];
        ssh_only = false;
        ssh_symbol = "SSH: ";
      };

      cmd_duration = let
        bg = "black";
        fg = "white";
        accent = "yellow";
      in {
        min_time = 1000;
        style = "fg:${accent} bg:${bg}";
        format = lib.concatStrings [
          "[\\(]($style)"
          "[took ](fg:${fg} bg:${bg})[$duration]($style)"
          "[\\) ]($style)"
        ];
      };

      character = let
        bg = "black";
        fg_success = "green";
        fg_error = "red";
      in {
          success_symbol = "[[](fg:${bg})](bold fg:${fg_success} bg:${bg})";
          error_symbol = "[[](fg:${bg})](bold fg:${fg_error} bg:${bg})";
      };
    };
  };
}
