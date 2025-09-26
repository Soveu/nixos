{
  config,
  pkgs,
  ...
}:
let
  username = config.soveu.username;
in
{
  nix.gc = {
    persistent = true;
    dates = "weekly";
    automatic = true;
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    eog
    gitFull
    wget
    openssl
    htop
    file
    zip
    unzip
  ];

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.vim-full;
  };

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

  users.groups."dummyGroup" = {
    gid = 1000;
    members = [ username ];
  };
}
