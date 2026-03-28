{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.gamingConfiguration = { pkgs,lib, ... }: {
    imports = [
      self.nixosModules.gamingHardware
    ];

    nix.settings = {
      download-buffer-size = 1024 * 1024 * 1024;
      experimental-features = [ "nix-command" "flakes" ];
    };

    services.pipewire.alsa.support32Bit = lib.mkForce false;
    hardware.graphics.enable32Bit = lib.mkForce false;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    networking.hostName = "gaming";
    system.stateVersion = "25.05";
  };
}
