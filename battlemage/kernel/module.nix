{
  pkgs,
  lib,
  ...
}:
let
  customStdenv = pkgs.withCFlags [ "-march=znver5" "-mtune=znver5" ] pkgs.gcc15Stdenv;
  linux_drm_tip = pkgs.callPackage ./linux-drm-tip.nix { stdenv = customStdenv; };
  finalPackage = lib.recurseIntoAttrs (pkgs.linuxPackagesFor linux_drm_tip);

  # nixos/modules/system/boot/kernel.nix
  undefault_kmod_names = [
    "af_alg"
    "algif_skcipher"
    "dm_crypt"
    "pcips2"
    "tpm-crb"
    "tpm-tis"
    "8250_dw"
    "uinput"

    "dm-raid"
    "dm-snapshot"
    "raid0"
    "raid456"
    "dm-mod"
    "md-mod"

    "hid_generic"
    "hid_lenovo"
    "hid_apple"
    "hid_roccat"
    "hid_logitech_hidpp"
    "hid_logitech_dj"
    "hid_microsoft"
    "hid_cherry"
    "hid_corsair"

    "ahci"
    "ata_piix"
    "sata_inic162x"
    "sata_nv"
    "sata_promise"
    "sata_qstor"
    "sata_sil"
    "sata_sil24"
    "sata_sis"
    "sata_svw"
    "sata_sx4"
    "sata_uli"
    "sata_via"
    "sata_vsc"

    "pata_ali"
    "pata_amd"
    "pata_artop"
    "pata_atiixp"
    "pata_efar"
    "pata_hpt366"
    "pata_hpt37x"
    "pata_hpt3x2n"
    "pata_hpt3x3"
    "pata_it8213"
    "pata_it821x"
    "pata_jmicron"
    "pata_marvell"
    "pata_mpiix"
    "pata_netcell"
    "pata_ns87410"
    "pata_oldpiix"
    "pata_pcmcia"
    "pata_pdc2027x"
    "pata_qdi"
    "pata_rz1000"
    "pata_serverworks"
    "pata_sil680"
    "pata_sis"
    "pata_sl82c105"
    "pata_triflex"
    "pata_via"
    "pata_winbond"
  ];

  undefault_kmods = lib.lists.foldr
    (item: acc: (acc // { "${item}" = lib.mkForce false; }))
    {}
    undefault_kmod_names ;
in
{
  boot.kernelPackages = finalPackage;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.blacklistedKernelModules = [ "i915" ];
  # boot.kernelParams = [ "i915.modeset=0" ];
  environment.systemPackages = [ finalPackage.cpupower ];

  boot.kernelModules = undefault_kmods;
  boot.initrd.availableKernelModules = undefault_kmods;
  boot.initrd.kernelModules = undefault_kmods;
}
