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

  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    intel-media-driver
    intel-compute-runtime
    vpl-gpu-rt
  ];

  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.intel-vaapi-driver
    driversi686Linux.intel-media-driver
  ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
    intel-undervolt
    intel-gpu-tools
  ];
}
