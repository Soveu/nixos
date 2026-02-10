{
  lib,
  buildLinux,
  ...
} @ args:
let
  version = "6.19.0";

  leanExtraConfig = import ./lean-extra-config.nix { inherit lib; };

  structuredExtraConfig = with lib.kernel; leanExtraConfig // {
    # FRAMEBUFFER_CONSOLE = lib.mkForce unset;
    # FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = lib.mkForce unset;
    # FRAMEBUFFER_CONSOLE_DETECT_PRIMARY = lib.mkForce unset;
    # FRAMEBUFFER_CONSOLE_ROTATION = lib.mkForce unset;
    # VT = no;

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

  inherit structuredExtraConfig;
} // (args.argsOverride or {}))
