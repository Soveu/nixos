{
  lib,
  llvmPackages,
  origMesa,
  ...
}:
let
  galliumDrivers = [ "iris" ]; # ideally, we want to use only zink
  eglPlatforms = [ "x11" "wayland" ];
  vulkanDrivers = [ "intel" ];

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
    (lib.mesonOption "clang-libdir" "${lib.getLib llvmPackages.clang-unwrapped}/lib")

    # You have Battlemage, right?
    (lib.mesonEnable "intel-rt" true)

    # Not needed
    (lib.mesonEnable "gallium-vdpau" false)
    (lib.mesonEnable "gallium-va" false)
    (lib.mesonEnable "android-libbacktrace" false)
  ];

  outputs = ["out"];
  patches = [./new-mesa-patch.diff];

  src = builtins.fetchGit /var/stuff/foss/mesa;
  version = "25.3.0-devel";
in
origMesa.overrideAttrs {
  inherit src;
  inherit version;
  inherit patches;

  inherit mesonFlags;
  inherit outputs;

  postInstall = null;
  env.MESON_PACKAGE_CACHE_DIR = "";
}
