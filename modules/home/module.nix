{
  self,
  inputs,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.nixosModules.home =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "soveu";
      llm-agents = inputs.llm-agents.packages."${pkgs.stdenv.hostPlatform.system}";
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = true;
      home-manager.verbose = true;
      home-manager.backupFileExtension = "bak";
      home-manager.sharedModules = [
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      home-manager.users."${username}" = {
        imports = [
          ./_dconf.nix
          self.homeModules.home-vim
          self.homeModules.home-kde
        ];

        programs.fish = {
          enable = true;
          shellAbbrs = {
            ":q" = "exit";
          };
        };

        home.packages = with pkgs; [
          vlc
          crosspipe
          desmume
          melonds
          transmission_4-gtk
          keepassxc

          alacritty
          btop
          gitFull
          gimp3-with-plugins
          ripgrep
          nixfmt
          man-pages-posix
          vulkan-tools

          gcc
          python3
          rustup

          orca-slicer
          prusa-slicer
          blender
          # freecad https://github.com/NixOS/nixpkgs/issues/540609
          appimage-run

          (llm-agents.dsh.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              substituteInPlace \
                $out/lib/node_modules/@deepseek-ai/dsh/node_modules/@deepseek-ai/dsh-app-boot/lib/index.js \
                --replace-fail \
                'createRequire(import.meta.url)("node-addon-require-builtin")' \
                '{ requireBuiltin: createRequire(import.meta.url) }'
            '';
          }))
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
