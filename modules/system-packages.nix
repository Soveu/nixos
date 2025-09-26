{
  config,
  pkgs,
  ...
}:
{
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
}
