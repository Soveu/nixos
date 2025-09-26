{
  config,
  pkgs,
  ...
}:
let
  username = config.soveu.username;
in
{
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    initialPassword = username;
    extraGroups = [ "networkmanager" "wheel" "dummyGroup" ];

    uid = 1000;

    home = "/home/${username}";
    createHome = false;
    shell = pkgs.fish;
    useDefaultShell = false;
  };

  # TODO: I need to change the group of my files in /home
  users.groups."dummyGroup" = {
    gid = 1000;
    members = [ username ];
  };
}
