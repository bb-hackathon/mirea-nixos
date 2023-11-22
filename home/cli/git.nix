# INFO: Git VCS
_: {
  programs.git = {
    enable = true;
    extraConfig.init.defaultBranch = "main";
    lfs.enable = true;
  };
}
