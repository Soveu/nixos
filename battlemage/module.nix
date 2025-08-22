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

  # hardware.graphics.package = lib.mkForce (pkgs.callPackage ./mesa2.nix {});
  # nixpkgs.overlays = [(final: prev: {
  #   mesa = final.callPackage ./mesa2.nix { };
  # })];

  # nixpkgs.overlays = [(final: prev: {
  #   mesa = final.callPackage ./mesa.nix { origMesa = prev.mesa; };
  # })];
}
