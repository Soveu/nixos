{
  pkgs,
  ...
}:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = [ pkgs.vimPlugins.rust-vim ];
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      mouse = null;
      shiftwidth = 4;
    };
    extraConfig = ''
      set hlsearch wrap
      set autoindent smartindent expandtab softtabstop=4
      set noswapfile nocompatible nowrapscan
      set encoding=utf-8
      set textwidth=90

      set splitbelow splitright
      map <C-j> <C-W>j
      map <C-h> <C-W>h
      map <C-k> <C-W>k
      map <C-l> <C-W>l
    '';
  };
}
