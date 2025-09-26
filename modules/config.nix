{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.soveu;
in
{
  options.soveu = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "soveu";
    };

    unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [ "steam" ];
      description = "Packages to include in nixpkgs.config.allowUnfreePredicate";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (lib.getName pkg) cfg.unfreePackages);
  };
}
