{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.user =
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
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    initialPassword = username;
    extraGroups = [ "networkmanager" "wheel" ];
    home = "/home/${username}";
    createHome = false;
    shell = pkgs.fish;
    useDefaultShell = false;
  };
};
}
