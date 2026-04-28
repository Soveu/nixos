{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.home =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "soveu";
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = true;
      home-manager.verbose = true;
      home-manager.backupFileExtension = "bak";

      home-manager.users."${username}" = {
        imports = [
          ./_dconf.nix
          self.homeModules.home-vim
        ];

        programs.fish = {
          enable = true;
          shellAbbrs = {
            ":q" = "exit";
          };
        };

        home.packages = [
          pkgs.vlc
          pkgs.crosspipe
          pkgs.desmume
          pkgs.transmission_4-gtk

          pkgs.alacritty
          pkgs.btop
          pkgs.gitFull
          pkgs.gimp3-with-plugins
          pkgs.ripgrep
          pkgs.nixfmt
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

          settings = {
            fetch.recurseSubmodules = false;
            diff.tool = "vimdiff";
            core.editor = "vim";
          };
        };

        home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;

        home.stateVersion = "25.05";
      };
    };
}
