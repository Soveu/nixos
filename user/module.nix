{
  pkgs,
  ...
}:
let
  username = "soveu";
in
{
  imports = [
    <home-manager/nixos>
  ];
  
  nix.gc = {
    persistent = true;
    dates = "weekly";
    automatic = true;
  };

  services.fwupd.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;

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

  environment.systemPackages = with pkgs; [
    eog
    gitFull
    wget
    openssl
    htop
    file
    zip
    unzip
  ];

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.vim-full;
  };

  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    initialPassword = username;
    extraGroups = [ "networkmanager" "wheel" "dummyGroup" ];

    uid = 1000;

    home = "/home/${username}";
    createHome = false;
    shell = pkgs.fish;
    useDefaultShell = false;
  };

  users.groups."dummyGroup" = {
    gid = 1000;
    members = [ username ];
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = "bak";

  home-manager.users."${username}" = {
    imports = [
      ./dconf.nix
      ./vim.nix
    ];

    programs.fish = {
      enable = true;
      shellAbbrs = {
        ":q" = "exit";
      };
    };

    home.packages = [
      pkgs.ungoogled-chromium
      pkgs.libreoffice
      pkgs.vlc
      pkgs.gnome-secrets
      pkgs.gnome-characters
      pkgs.gnome-tweaks

      pkgs.alacritty
      pkgs.btop
      pkgs.gitFull
      pkgs.gimp3-with-plugins
      pkgs.gdb
      pkgs.ripgrep
      pkgs.nixfmt-rfc-style
      pkgs.dpkg
      pkgs.man-pages-posix
      pkgs.vulkan-tools

      pkgs.gcc14
      pkgs.python3
      pkgs.rustup
    ];

    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;

      extraConfig = {
        fetch.recurseSubmodules = false;
        diff.tool = "vimdiff";
        core.editor = "vim";
      };
    };

    home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;

    home.stateVersion = "25.05";
  };
}
