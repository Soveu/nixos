{
  config,
  pkgs,
  lib,
  ... 
}:
{
  imports = [
    ./hardware-workarounds.nix
    ./user/module.nix
    ./battlemage/module.nix
    ./no32bit.nix
  ];

  nixpkgs.config.allowUnfreePredicate = (pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ]
  );

  programs.obs-studio.enable = true;
  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.mangohud ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gaming";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.libinput.enable = true;

  console.keyMap = "pl2";
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
