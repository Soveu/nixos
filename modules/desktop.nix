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
      de = "kde";
      useGnome = (de == "gnome");
      useCosmic = (de == "cosmic");
      useKde = (de == "kde");

      dePkgs = with pkgs; {
        gnome = [
          gnome-secrets
          gnome-characters
          gnome-tweaks
          loupe
        ];

        cosmic = [
          gnome-secrets
          gnome-characters
        ];

        kde = [];
      };

      username = "soveu";
      imageFormats = [
        "png"
        "gif"
        "webp"
        "tiff"
        "bmp"
        "avif"
        "jxl"
      ];
      imageViewer = "org.gnome.Loupe.desktop";

      defaultImageApp = lib.lists.foldr (
        item: acc: (acc // { "image/${item}" = imageViewer; })
      ) { } imageFormats;
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

      services.displayManager.gdm.enable = useGnome;
      services.desktopManager.gnome.enable = useGnome;

      services.displayManager.cosmic-greeter.enable = useCosmic;
      services.desktopManager.cosmic.enable = useCosmic;
      services.desktopManager.cosmic.xwayland.enable = useCosmic;

      services.displayManager.plasma-login-manager.enable = useKde;
      services.desktopManager.plasma6.enable = useKde;

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

      environment.systemPackages = dePkgs."${de}";

      # TODO: how does cosmic/kde handle this?
      # xdg.mime.defaultApplications = {
      #   "application/pdf" = "firefox.desktop";
      # }
      # // defaultImageApp;
    };
}
