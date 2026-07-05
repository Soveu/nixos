{
  lib,
  buildLinux,
  src,
  ...
}@args:
let
  version = "7.2.0-rc1";

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

      # Issue starting with
      #
      # commit 364f4a55c661641c02c86a849f0608d8fc3c0006
      # Merge: e4b4bfaa5090 1c2b66a7d725
      # Author: Linus Torvalds <torvalds@linux-foundation.org>
      # Date:   Mon Jun 22 12:09:47 2026 -0700
      #
      #     Merge tag 'usb-7.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
      #
      # commit 9e896b4a48c4e815956d28961448041c80ad5a19 (HEAD)
      # Author: Jihong Min <hurryman2212@gmail.com>
      # Date:   Tue May 19 09:07:31 2026 +0900
      #
      #     usb: xhci-pci: add AMD Promontory 21 PCI glue
      USB_XHCI_PCI_PROM21 = lib.mkForce unset;
      SENSORS_PROM21_XHCI = lib.mkForce no;
    };
in
buildLinux (
  args
  // {
    inherit version src structuredExtraConfig;
    modDirVersion = version;
    extraMeta.branch = "drm-tip";

    kernelPatches = [
      {
        name = "infinity-scheduler";
        # Cannot use patches for 7.1 from github, had to make a custom one
        patch =  ./infinity-scheduler.patch;
      }
    ];
  }
  // (args.argsOverride or { })
)
