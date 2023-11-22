{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ fd ];
    file.".fdignore".text = /* git-ignore */ ''
      .git/
    '';
  };
}
