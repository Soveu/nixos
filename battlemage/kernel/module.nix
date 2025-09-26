{
  pkgs,
  lib,
  ...
}:
let
  linux_drm_tip = pkgs.callPackage ./linux-drm-tip.nix { stdenv = pkgs.gcc15Stdenv; };
  finalPackage = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_drm_tip);

  undefault_kmod_names = [
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

  boot.kernelModules = undefault_kmods;
  boot.initrd.availableKernelModules = undefault_kmods;
  boot.initrd.kernelModules = undefault_kmods // {
    "xe" = true;
  };

  boot.kernelParams = [
    "plymouth.use-simpledrm=0"
    "split_lock_detect=off"
    "page_poison=0"
  ];
}
