{
  config,
  pkgs,
  lib,
  ... 
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.initrd.luks.mitigateDMAAttacks = false;
  boot.initrd.luks.devices."luks-cafc4a9a-36a4-42cc-973b-986f9f5aaca7".preLVM = false; # LUKS is inside LVM
  boot.initrd.luks.devices."luks-cafc4a9a-36a4-42cc-973b-986f9f5aaca7".allowDiscards = true;
  boot.initrd.luks.devices."luks-cafc4a9a-36a4-42cc-973b-986f9f5aaca7".bypassWorkqueues = true;
  boot.initrd.kernelModules = [ "dm-raid" "dm-mod" "md-mod" "raid456" "raid0" ];
}
