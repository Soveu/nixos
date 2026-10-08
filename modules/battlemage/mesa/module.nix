{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.battlemage-mesa =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      mesaOverlay = (
        final: prev: {
          mesa =
            (prev.mesa.overrideAttrs {
              src = inputs.git-mesa;
              version = "26.3.0-devel";
              buildInputs = prev.mesa.buildInputs ++ [ prev.libdisplay-info ];
              patches = prev.mesa.patches ++ [ ./panvk.patch ];
            }).override
              {
                stdenv = final.withCFlags [ "-march=znver5" "-mtune=znver5" ] final.gcc16Stdenv;
                galliumDrivers = [
                  "iris"
                  "llvmpipe"
                  "zink"
                ]
                ++ [
                  "asahi"
                  "panfrost"
                  "virgl"
                ];
                vulkanDrivers = [
                  "intel"
                  "swrast"
                ]
                ++ [
                  "asahi"
                  "panfrost"
                  "microsoft-experimental"
                ];
                # Vulkan layers available in Mesa 26.3.0 (anti-lag was removed upstream)
                vulkanLayers = [
                  "device-select"
                  "intel-nullhw"
                  "overlay"
                  "screenshot"
                  "vram-report-limit"
                ];
              };
        }
      );
    in
    {
      nixpkgs.overlays = [
        mesaOverlay
      ];
    };
}
