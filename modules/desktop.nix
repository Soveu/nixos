{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.soveu.username;
in
{
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.libinput.enable = true;

  console.keyMap = "pl2";
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.hasklug
    nerd-fonts.im-writing
    nerd-fonts.ubuntu-mono
    source-code-pro
    terminus_font
  ];
}
