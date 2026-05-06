{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.home-kde =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.plasma.enable = true;
      # programs.plasma.immutableByDefault = true;
      # programs.plasma.input

      programs.plasma.configFile = {
        plasma-localerc.Formats.LANG = "en_US.UTF-8";
        plasmarc.Theme.name = "breeze-dark";
        kdeglobals.QtQuickRendererSettings.RenderLoop = "threaded";
        kdeglobals.QtQuickRendererSettings.SceneGraphBackend = "vulkan";
      };

      programs.plasma.workspace = {
        colorScheme = "BreezeDark";
        lookAndFeel = "org.kde.breezedark.desktop";
        theme = "breeze-dark";
      };
    };
}
