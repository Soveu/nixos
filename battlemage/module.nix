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
  imports = [
    ./kernel.nix
  ];

  # hardware.graphics.package = lib.mkForce (pkgs.callPackage ./mesa-git/package.nix {});
  nixpkgs.overlays = [
    mesaOverlay
  ];
  # nixpkgs.overlays = [(final: prev: {
  #   mesa = prev.mesa.overrideAttrs {
  #     version = "25.2.2";

  #     src = prev.fetchFromGitLab {
  #       domain = "gitlab.freedesktop.org";
  #       owner = "mesa";
  #       repo = "mesa";
  #       rev = "mesa-25.2.2";
  #       hash = "sha256-9w/E5frSvCtPBI58ClXZyGyF59M+yVS4qi4khpfUZwk=";
  #     };
  #   };
  # })];
}
