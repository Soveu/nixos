{
  pkgs,
  ...
}:
let
  version = "6.16.0";

  linux_drm_tip_pkg = { buildLinux, ... } @ args: (
    buildLinux (args // {
      inherit version;
      modDirVersion = version;

      src = builtins.fetchGit /var/stuff/foss/drm-tip;
      kernelPatches = [];
      extraMeta.branch = "drm-tip";
    } // (args.argsOverride or {}))
  );

  linux_drm_tip = pkgs.callPackage linux_drm_tip_pkg {};
  finalPackage = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_drm_tip);
in
{
  boot.kernelPackages = finalPackage;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Force early loading of drivers for better boot experience
  # boot.plymouth.enable = true;
  boot.initrd.kernelModules = [ "xe" "usbhid" ];
  boot.kernelParams = ["plymouth.use-simpledrm=0"];
}
