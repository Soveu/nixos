{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.initrd.kernelModules = [
    "atkbd"
    "hid_generic"
    "usbhid"
    "hid"
    "xhci_hcd"
    "8250_dw"
    "libps2"
    "serio"
    "uinput"
  ];
  boot.consoleLogLevel = 0;

  # boot.plymouth.enable = true;

  services.kmscon = {
    enable = true;
    hwRender = true;
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  boot.kernelParams = [
    "plymouth.use-simpledrm=0"
    "plymouth.graphical"
    "plymouth.ignore-serial-consoles"
    "plymouth.nolog"
    # "quiet"
    # "udev.log_priority=3"

    "split_lock_detect=off"
    "page_poison=0"
    "transparent_hugepage=always"
  ];
}
