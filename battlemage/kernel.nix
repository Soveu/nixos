{
  pkgs,
  lib,
  ...
}:
let
  version = "6.17.0-rc4";

  _force_unset = [
    "AIC79XX_DEBUG_ENABLE"
    "AIC7XXX_DEBUG_ENABLE"
    "AIC94XX_DEBUG"
    "ATH10K_DFS_CERTIFIED"
    "ATH9K_AHB"
    "ATH9K_DFS_CERTIFIED"
    "ATH9K_PCI"
    "B43_PHY_HT"
    "BRCMFMAC_PCIE"
    "BRCMFMAC_USB"
    "BT_HCIBTUSB_AUTOSUSPEND"
    "BT_HCIBTUSB_MTK"
    "BT_HCIUART"
    "BT_HCIUART_BCM"
    "BT_HCIUART_BCSP"
    "BT_HCIUART_H4"
    "BT_HCIUART_LL"
    "BT_HCIUART_QCA"
    "BT_HCIUART_SERDEV"
    "BT_QCA"
    "BT_RFCOMM_TTY"
    "CFG80211_CERTIFICATION_ONUS"
    "CFG80211_DEBUGFS"
    "CFG80211_WEXT"
    "CRC32_SELFTEST"
    "CRYPTO_TEST"
    "DRM_AMD_ACP"
    "DRM_AMD_DC_FP"
    "DRM_AMD_DC_SI"
    "DRM_AMDGPU_CIK"
    "DRM_AMDGPU_SI"
    "DRM_AMDGPU_USERPTR"
    "DRM_AMD_ISP"
    "DRM_AMD_SECURE_DISPLAY"
    "DRM_I915_GVT"
    "DRM_I915_GVT_KVMGT"
    "DRM_NOUVEAU_GSP_DEFAULT"
    "DRM_NOUVEAU_SVM"
    "HAVA_PATA_PLATFORM"
    "HSA_AMD"
    "IPW2100_MONITOR"
    "IPW2200_MONITOR"
    "MAC80211_DEBUGFS"
    "MAC80211_MESH"
    "MEGARAID_NEWGEN"
    "NET_FC"
    "NVIDIA_SHIELD_FF"
    "POWER_RESET_GPIO"
    "POWER_RESET_GPIO_RESTART"
    "REISERFS_FS_POSIX_ACL"
    "REISERFS_FS_SECURITY"
    "REISERFS_FS_XATTR"
    "RT2800USB_RT53XX"
    "RT2800USB_RT55XX"
    "RTL8XXXU_UNTESTED"
    "RTW88"
    "RTW88_8822BE"
    "RTW88_8822CE"
    "SATA_HOST"
    "SATA_MOBILE_LPM_POLICY"
    "SCSI_SAS_ATA"
  ];

  force_unset = lib.lists.foldr
    (item: acc: (acc // { "${item}" = lib.mkForce lib.kernel.unset; }))
    {}
    _force_unset;

  _force_no = [
    "AGP"
    # "CHROME_PLATFORMS"
    # "MEDIA_ANALOG_TV_SUPPORT"
    # "MEDIA_DIGITAL_TV_SUPPORT"
    # "MEDIA_RADIO_SUPPORT"
    # "MEDIA_ATTACH"
    # "MEDIA_TUNER"
    # "FIREWIRE"
    # "DVB_CORE"
    # "VIDEO_TUNER"
    # "SURFACE_PLATFORMS"
    # "X86_PLATFORM_DRIVERS_DELL"
    # "X86_PLATFORM_DRIVERS_HP"
    # "X86_PLATFORM_DRIVERS_LENOVO"
    # "X86_PLATFORM_DRIVERS_TUXEDO"
    # "X86_PLATFORM_DRIVERS_SIEMENS"
    # "X86_ANDROID_TABLETS"
    # "COMPAL_LAPTOP"
    # "LG_LAPTOP"
    # "PANASONIC_LAPTOP"
    # "SONY_LAPTOP"
    # "TOPSTAR_LAPTOP"
    # "X86_EXTENDED_PLATFORM"
    # "XEN"
    # "SLAB_FREELIST_HARDENED"
    # "NFS_FS"
    # "GREYBUS"
    # "COMEDI"
    # "USB_GADGET"
  ];

  force_no = lib.lists.foldr
    (item: acc: (acc // { "${item}" = lib.mkForce lib.kernel.no; }))
    {}
    _force_no;

  linux_drm_tip_pkg = { buildLinux, ... } @ args: (
    buildLinux (args // {
      inherit version;
      modDirVersion = version;

      src = builtins.fetchGit /var/stuff/foss/tip;
      kernelPatches = [];
      extraMeta.branch = "drm-tip";

      structuredExtraConfig = with lib.kernel; {
        # Faster boot
        # USB_KBD = yes;
        # DRM_XE = yes;

        # Better perf
        NTSYNC = yes;
        # BPF_JIT_ALWAYS_ON = lib.mkForce yes;
        # RCU_BOOST = yes; # unused option???

        # Remove unneeded video drivers
        DRM_AMDGPU = no;
        DRM_RADEON = no;
        DRM_NOVA = no;
        DRM_NOUVEAU = no;
        DRM_I915 = no;

        # Remove bluetooth, wifi, sata
        BT = no;
        WIRELESS = no;
        WLAN = no;
        ATA = no;
        SATA_HOST = no;
        # SCSI = no; # USB depends on it
        HAVA_PATA_PLATFORM = no;

        # MITIGATION_xxx
      }
      // force_no
      // force_unset;

    } // (args.argsOverride or {}))
  );

  linux_drm_tip = pkgs.callPackage linux_drm_tip_pkg {};
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

    # "3w-9xxx"
    # "3w-xxxx"
    # "aic79xx"
    # "aic7xxx"
    # "arcmsr"
    # "hpsa"
    # "sd_mod"
    # "sr_mod"
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
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Force early loading of drivers for better boot experience
  # boot.plymouth.enable = true;
  boot.initrd.kernelModules = {
    "xe" = true;
    "usbhid" = true;
  } // undefault_kmods;

  boot.kernelParams = [
    "plymouth.use-simpledrm=0"
    "split_lock_detect=off"
    "page_poison=0"
  ];
}
