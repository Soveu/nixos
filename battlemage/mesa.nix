{
  pkgs,
  lib,
  ...
}:
let
  galliumDrivers = [ "zink" ];
  eglPlatforms = [ "x11" "wayland" ];
  vulkanDrivers = [
    "intel"
    "swrast"
  ];

  # default
  vulkanLayers = [
    "device-select"
    "intel-nullhw"
    "overlay"
    "screenshot"
    "vram-report-limit"
  ];

  mesonFlags = [
    # Kind of mandatory
    "--sysconfdir=/etc"
    (lib.mesonEnable "gbm" true)
    (lib.mesonEnable "glvnd" true)
    (lib.mesonBool "libgbm-external" true)
    (lib.mesonOption "platforms" (lib.concatStringsSep "," eglPlatforms))
    (lib.mesonOption "gallium-drivers" (lib.concatStringsSep "," galliumDrivers))
    (lib.mesonOption "vulkan-drivers" (lib.concatStringsSep "," vulkanDrivers))
    (lib.mesonOption "vulkan-layers" (lib.concatStringsSep "," vulkanLayers))

    # You have Battlemage, right?
    (lib.mesonEnable "intel-rt" true)

    # Not needed
    (lib.mesonEnable "gallium-vdpau" false)
    (lib.mesonEnable "gallium-va" false)
    (lib.mesonEnable "android-libbacktrace" false)
  ];
in
pkgs.mesa.overrideAttrs {
  inherit mesonFlags;
}
