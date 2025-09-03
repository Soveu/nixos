let
  pkgs = import <nixpkgs> {};
in
{
  new_mesa = pkgs.callPackage ./package.nix { };
}
