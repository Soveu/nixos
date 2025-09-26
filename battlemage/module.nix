{
  config,
  pkgs,
  lib,
  ... 
}:
{
  imports = [
    ./kernel/module.nix
    ./mesa/module.nix
  ];
}
