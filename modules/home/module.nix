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
  imports = [
    <home-manager/nixos>
  ];

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
      pkgs.helvum

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

      pkgs.gcc15
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
