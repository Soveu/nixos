{
  config,
  pkgs,
  lib,
  ...
}:
let
  mesaOverlay = (final: prev: {
    mesa = (prev.mesa.overrideAttrs {
      src = builtins.fetchGit /var/stuff/foss/mesa;
      version = "25.3.0-devel";
      buildInputs = prev.mesa.buildInputs ++ [prev.libdisplay-info];
    }).override {
      stdenv = final.gcc15Stdenv;
    };
  });
in
{
  nixpkgs.overlays = [
    mesaOverlay
  ];
}
