{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.soveu.username;
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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.libinput.enable = true;

  # services.xserver.displayManager.gdm.enable = false;
  # services.xserver.desktopManager.gnome.enable = false;
  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;
  # services.desktopManager.cosmic.xwayland.enable = true;

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

  # https://github.com/NixOS/nixpkgs/issues/449657
  fonts.fontconfig.localConf = ''
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <description>Accept bitmap fonts</description>
<!-- Accept bitmap fonts -->
 <selectfont>
  <acceptfont>
   <pattern>
     <patelt name="outline"><bool>false</bool></patelt>
   </pattern>
  </acceptfont>
 </selectfont>
</fontconfig>
  '';

  environment.systemPackages = [
    pkgs.gnome-secrets
    pkgs.gnome-characters
    pkgs.gnome-tweaks
    pkgs.loupe
  ];

  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
  } // defaultImageApp;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
