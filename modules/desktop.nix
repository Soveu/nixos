{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.desktop =
{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = "soveu";
  useCosmic = false; # https://github.com/NixOS/nixpkgs/pull/502494
  imageFormats = ["png" "gif" "webp" "tiff" "bmp" "avif" "jxl"];
  imageViewer = "org.gnome.Loupe.desktop";

  defaultImageApp = lib.lists.foldr
    (item: acc: (acc // { "image/${item}" = imageViewer; }))
    {}
    imageFormats;
in
{
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;
  services.libinput.enable = true;

  console.keyMap = "pl2";
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  services.displayManager.gdm.enable = !useCosmic;
  services.desktopManager.gnome.enable = !useCosmic;
  services.displayManager.cosmic-greeter.enable = useCosmic;
  services.desktopManager.cosmic.enable = useCosmic;
  services.desktopManager.cosmic.xwayland.enable = useCosmic;

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

  environment.systemPackages = [
    pkgs.gnome-secrets
    pkgs.gnome-characters
  ] ++ (if useCosmic then [] else [
    pkgs.gnome-tweaks
    pkgs.loupe
  ]);

  # TODO: how does cosmic handle this?
  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
  } // defaultImageApp;
};
}
