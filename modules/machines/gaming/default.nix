{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.gaming = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.gamingConfiguration
      self.nixosModules.desktop
      self.nixosModules.kernel
      self.nixosModules.system-packages
      self.nixosModules.user
      self.nixosModules.home

      self.nixosModules.steam
      self.nixosModules.obs
      self.nixosModules.battlemage
    ];
  };
}
