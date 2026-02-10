{
  config,
  pkgs,
  lib,
  ...
}:
let
  kilo = 1024;
  mega = kilo * kilo;
  giga = mega * kilo;
in
{
  imports = [
    ./hardware-workarounds.nix
    ./battlemage/module.nix

    ./modules/config.nix
    ./modules/desktop.nix
    ./modules/firewall.nix
    ./modules/home/module.nix
    ./modules/kernel.nix
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

  nix.settings.download-buffer-size = giga;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
      obs-vaapi
      obs-pipewire-audio-capture
      obs-gstreamer
      input-overlay
    ];
  };
  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.mangohud ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # boot.kernelParams = [
  #   "default_hugepagesz=1G"
  #   "hugepagesz=1G"
  #   "hugepages=16"
  # ];
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
