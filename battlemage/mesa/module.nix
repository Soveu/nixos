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
      stdenv = final.withCFlags [ "-march=znver5" "-mtune=znver5" ] final.gcc15Stdenv;
      galliumDrivers = [ "iris" "llvmpipe" "zink" ] ++ [ "asahi" "panfrost" "virgl" ];
      vulkanDrivers = [ "intel" "swrast" ] ++ [ "asahi" "panfrost" "microsoft-experimental" ];
    };
  });
in
{
  nixpkgs.overlays = [
    mesaOverlay
  ];
}
