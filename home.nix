{ config, pkgs, ... }:
{
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
  ];

  programs.vim = {
    plugins = with pkgs.vimPlugins; [ vim-airline ];
  };

  imports = [
    ./programs/alacritty.nix
  ];

  #services.gpg-agent = {
  #  enable = true;
  #  defaultCacheTtl = 1800;
  #  enableSshSupport = true;
  #};
}
