{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.obs = { config, pkgs, lib, ... }: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-gstreamer
        input-overlay
      ];
    };
  };
}
