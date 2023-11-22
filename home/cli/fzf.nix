# INFO: `fzf`, a general-purpose command-line fuzzy finder
{ config, ... }: let
  inherit (config.theme) colors;
in {
  programs.fzf = {
    enable = true;

    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    colors = rec {
      bg = "#${colors.base}"; # Background
      fg = "#${colors.surface2}"; # Text
      "bg+" = bg; # Background (current line)
      "fg+" = "#${colors.text}"; # Text (current line)
      hl = fg; # Highlighted substrings
      "hl+" = "#${colors.green}"; # Highlighted substrings (current line)
      preview-bg = bg; # Background (preview window)
      preview-fg = "#${colors.text}"; # Text (preview window)
      gutter = bg; # Gutter on the left (defaults to bg+)
      info = "#${colors.surface2}";
      border = "#${colors.surface0}"; # Border of the preview window and horizontal separators (--border)
      prompt = "#${colors.mauve}";
      pointer = "#${colors.green}";
      spinner = "#${colors.peach}"; # Streaming input indicator
      header = "#${colors.surface2}";
    };

    defaultCommand = null;
    defaultOptions = [
      "--border"
      "--height 40%"
      "--bind=tab:down"
      "--bind=btab:up"
      "--bind=alt-j:down"
      "--bind=alt-k:up"
    ];

    # CTRL+T
    fileWidgetCommand = null;
    fileWidgetOptions = [
      "--preview 'bat -nf {}'"
    ];

    # ALT+C
    changeDirWidgetCommand = "fd --type directory --hidden";
    # changeDirWidgetOptions = [
    #   "--preview 'erd --dirs-only --suppress-size --icons --layout inverted {} | head -n 100'"
    # ];

    # CTRL+R
    historyWidgetOptions = [
      "--exact"
    ];
  };
}