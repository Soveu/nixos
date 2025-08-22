let
  pkgs = import <nixpkgs> {};
in
{
  # new_mesa = pkgs.callPackage ./mesa.nix { origMesa = pkgs.mesa; };
  new_mesa = pkgs.callPackage ./mesa2.nix { };
}
