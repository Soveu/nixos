{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.steam =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      preload = "${pkgs.mimalloc}/lib/libmimalloc.so";
      gottaGoFast = pkgs.writeShellScriptBin "gotta-go-fast" ''
        MIMALLOC_ALLOW_LARGE_OS_PAGES=1 MIMALLOC_SHOW_ERRORS=1 LD_PRELOAD="$LD_PRELOAD:${preload}" "$@"
      '';

      predlist = [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];
    in
    {
      # So far the only unfree package here
      nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (lib.getName pkg) predlist);

      programs.steam = {
        enable = true;
        extraPackages = [
          pkgs.mangohud
          gottaGoFast
        ];
        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];
        dedicatedServer.openFirewall = true;
      };
    };
}
