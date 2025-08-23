{
  pkgs,
  lib,
  ...
}:
let
  version = "6.17.0-rc2";

  linux_drm_tip_pkg = { buildLinux, ... } @ args: (
    buildLinux (args // {
      inherit version;
      modDirVersion = version;

      src = builtins.fetchGit /var/stuff/foss/tip;
      kernelPatches = [];
      extraMeta.branch = "drm-tip";

      structuredExtraConfig = with lib.kernel; {
        # Does not exist
        DRM_NOUVEAU_GSP_DEFAULT = lib.mkForce unset;

        # Remove unneeded video drivers
        DRM_AMDGPU = no;
        DRM_RADEON = no;
        DRM_NOVA = no;
        DRM_NOUVEAU = no;
        DRM_I915 = no;

        # Remove bluetooth, wifi, sata
        BT = no;
        WIRELESS = no;
        WLAN = no;
        ATA = no;
        SATA_HOST = no;
        SCSI = no;
        HAVA_PATA_PLATFORM = no;
      };
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
