{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  boot.kernelParams = [
    "plymouth.use-simpledrm=0"
    "split_lock_detect=off"
    "page_poison=0"
    "transparent_hugepage=always"
  ];
}
