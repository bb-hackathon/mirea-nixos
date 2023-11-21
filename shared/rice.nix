{ lib, ... }: {
  options = {
    theme = lib.mkOption {
      type = lib.types.attrs;
    };
  };
}
