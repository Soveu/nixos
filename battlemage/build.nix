let
  pkgs = import <nixpkgs> {};
in
{
  new_mesa = pkgs.callPackage ./mesa.nix {};
}
