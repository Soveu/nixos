{
  lib,
  buildLinux,
  ...
} @ args:
let
  version = "6.19.0-rc5";

  leanExtraConfig = import ./lean-extra-config.nix { inherit lib; };

  structuredExtraConfig = with lib.kernel; leanExtraConfig // {
    NTSYNC = yes;

    PREEMPT_NONE = no;
    PREEMPT_VOLUNTARY = lib.mkForce no;
    PREEMPT = no;
    PREEMPT_DYNAMIC = lib.mkForce no;
    PREEMPT_LAZY = yes;
  };
in
buildLinux (args // {
  inherit version;
  modDirVersion = version;
  src = builtins.fetchGit /var/stuff/foss/tip;
  extraMeta.branch = "drm-tip";

  kernelPatches = [ {
    name = "rdseed-unpatch";
    patch = ./rdseed-unpatch.patch;
  } ];

  inherit structuredExtraConfig;
} // (args.argsOverride or {}))
