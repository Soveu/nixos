{
  lib,
  buildLinux,
  src,
  ...
}@args:
let
  version = "7.3.0-rc1";

  leanExtraConfig = import ./_lean-extra-config.nix { inherit lib; };

  structuredExtraConfig =
    with lib.kernel;
    leanExtraConfig
    // {
      # FRAMEBUFFER_CONSOLE = lib.mkForce unset;
      # FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = lib.mkForce unset;
      # FRAMEBUFFER_CONSOLE_DETECT_PRIMARY = lib.mkForce unset;
      # FRAMEBUFFER_CONSOLE_ROTATION = lib.mkForce unset;
      # VT = no;

      NTSYNC = yes;

      PREEMPT_NONE = lib.mkForce unset;
      PREEMPT_VOLUNTARY = lib.mkForce unset;
      PREEMPT_DYNAMIC = lib.mkForce no;

      PREEMPT_LAZY = lib.mkForce no;
      PREEMPT = lib.mkForce yes;
    };
in
buildLinux (
  args
  // {
    inherit version src structuredExtraConfig;
    modDirVersion = version;
    extraMeta.branch = "drm-tip";

    kernelPatches = [
      # Crashes, need to update
      # {
      #   name = "infinity-scheduler";
      #   # Cannot use patches for 7.1 from github, had to make a custom one
      #   patch =  ./infinity-scheduler.patch;
      # }
      {
        name = "tmp";
        patch =  ./rust_drm.patch;
      }
    ];
  }
  // (args.argsOverride or { })
)
