{
  config,
  pkgs,
  lib,
  ... 
}:
{
  imports = [
    ./kernel/module.nix
    ./mesa/module.nix
  ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
    intel-undervolt
    intel-gpu-tools
    intel-vaapi-driver
    intel-media-driver
  ];
}
