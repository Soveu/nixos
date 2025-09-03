{
  pkgs,
  ...
}:
let
  src = builtins.fetchGit /var/stuff/foss/mesa;
  version = "25.3.0-devel";
in
pkgs.mesa.overrideAttrs {
  inherit src;
  inherit version;

  buildInputs = pkgs.mesa.buildInputs ++ [pkgs.libdisplay-info];
}
