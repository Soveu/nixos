{
  config,
  pkgs,
  lib,
  ... 
}:
{
  services.pipewire.alsa.support32Bit = lib.mkForce false;
  hardware.graphics.enable32Bit = lib.mkForce false;
}
