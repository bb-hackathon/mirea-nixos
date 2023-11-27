# INFO: Helix, a post-modern vim-like editor

_: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "catppuccin-mocha";
      editor = {
        idle-timeout = 0;
        completion-trigger-len = 1;
        file-picker.hidden = false;
        indent-guides.render = true;
        color-modes = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
          ];
          center = [
            "file-base-name"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "position"
            "file-encoding"
            # "file-line-ending"
            "file-type"
          ];

          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        soft-wrap.enable = true;
      };

      keys = {
        insert = {
          "A-h" = "move_char_left";
          "A-j" = "move_line_down";
          "A-k" = "move_line_up";
          "A-l" = "move_char_right";
        };
      };
    };
  };
}
