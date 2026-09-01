{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.podman =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      virtualisation = {
        containers.enable = true;
        podman.enable = true;
        podman.dockerCompat = true;
      };

      environment.systemPackages = with pkgs; [
        podman-compose
      ];
    };
}


