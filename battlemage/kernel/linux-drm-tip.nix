{
  lib,
  buildLinux,
  ...
} @ args:
let
  version = "7.0.0-rc4";

  leanExtraConfig = import ./lean-extra-config.nix { inherit lib; };

  structuredExtraConfig = with lib.kernel; leanExtraConfig // {
    # FRAMEBUFFER_CONSOLE = lib.mkForce unset;
    # FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = lib.mkForce unset;
    # FRAMEBUFFER_CONSOLE_DETECT_PRIMARY = lib.mkForce unset;
    # FRAMEBUFFER_CONSOLE_ROTATION = lib.mkForce unset;
    # VT = no;

    NTSYNC = yes;

    PREEMPT_NONE = lib.mkForce unset;
    PREEMPT_VOLUNTARY = lib.mkForce unset;
    PREEMPT = lib.mkForce no;
    PREEMPT_DYNAMIC = lib.mkForce no;
    PREEMPT_LAZY = yes;
  };
in
buildLinux (args // {
  inherit version;
  modDirVersion = version;
  # git@ssh.gitlab.freedesktop.org:drm/tip.git
  src = builtins.fetchGit /var/stuff/foss/tip;
  extraMeta.branch = "drm-tip";

  inherit structuredExtraConfig;
} // (args.argsOverride or {}))
