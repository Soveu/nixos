{
  lib,
  buildLinux,
  ...
} @ args:
let
  version = "6.17.0-rc7";

  leanExtraConfig = import ./lean-extra-config.nix { inherit lib; };

  structuredExtraConfig = with lib.kernel; leanExtraConfig // {
    NTSYNC = yes;
  };
in
    buildLinux (args // {
      inherit version;
      modDirVersion = version;
      src = builtins.fetchGit /var/stuff/foss/tip;
      extraMeta.branch = "drm-tip";

      kernelPatches = [];
      inherit structuredExtraConfig;
    } // (args.argsOverride or {}))
