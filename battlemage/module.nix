{
  config,
  pkgs,
  lib,
  ... 
}:
{
  imports = [
    ./kernel.nix
  ];

  hardware.graphics.package = pkgs.callPackage ./mesa.nix {};
}
