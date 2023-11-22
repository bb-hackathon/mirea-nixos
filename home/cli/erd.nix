{ pkgs, ... }: {
  home.packages = with pkgs; [ erdtree ];
  xdg.configFile."erdtree/.erdtree.toml".text = /* toml */ ''
    # Always enabled
    icons = true
    human = true
    sort = "name"
    truncate = true
    layout = "inverted"
    dir_order = "last"

    [tree]
    icons = true
    human = true
    sort = "name"
    hidden = true
    no-git = true
    suppress-size = true
    truncate = true
    layout = "inverted"
    dir_order = "last"

    [sz]
    icons = true
    human = true
    level = 1
    hidden = true
    no-ignore = true
    disk_usage = "physical"
    sort = "size"
    prune = true
    truncate = true
    layout = "inverted"
  '';
}
