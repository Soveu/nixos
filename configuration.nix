{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-workarounds.nix
    ./battlemage/module.nix

    ./modules/config.nix
    ./modules/desktop.nix
    ./modules/home/module.nix
    ./modules/no32bit.nix
    ./modules/system-packages.nix
    ./modules/user.nix
  ];

  soveu = {
    username = "soveu";
    unfreePackages = [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
  };

  programs.obs-studio.enable = true;
  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.mangohud ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gaming";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
