{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.kernel =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      boot.initrd.systemd.enable = true;
      boot.initrd.verbose = false;
      # boot.consoleLogLevel = 0;
      boot.plymouth.enable = true;

      services.kmscon = {
        enable = true;
        config.hwaccel = true;
      };

      boot.kernelParams = [
        "plymouth.use-simpledrm=0"
        "plymouth.graphical"
        "plymouth.ignore-serial-consoles"
        "plymouth.nolog"
        "quiet"
        # "udev.log_priority=3"

        "split_lock_detect=off"
        "page_poison=0"
        "transparent_hugepage=always"
      ];
    };
}
