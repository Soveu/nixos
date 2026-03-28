{
  config,
  pkgs,
  lib,
  ...
}:
let
  mesaOverlay = (final: prev: {
    mesa = (prev.mesa.overrideAttrs {
      # git@ssh.gitlab.freedesktop.org:mesa/mesa.git
      src = builtins.fetchGit /stuff/foss/mesa;
      version = "26.1.0-devel";
      buildInputs = prev.mesa.buildInputs ++ [prev.libdisplay-info];
      # patches = prev.mesa.patches ++ [ ./zink-only.patch ];
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
