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
      version = "26.0.0-devel";
      buildInputs = prev.mesa.buildInputs ++ [prev.libdisplay-info];
      # patches = prev.mesa.patches ++ [ ./zink-only.patch ];
      # Remove the llvm21 patch that got merged
      patches = [ /var/stuff/foss/nixpkgs/pkgs/development/libraries/mesa/opencl.patch ];
    }).override {
      stdenv = final.withCFlags [ "-march=znver5" "-mtune=znver5" ] final.gcc15Stdenv;
      # galliumDrivers = [ "llvmpipe" "zink" ] ++ [ "asahi" "panfrost" "virgl" ];
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
