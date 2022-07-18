{ config, pkgs, ... }:
{
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    feh
    firefox
    spotify
  ];

  programs.vim = {
    plugins = with pkgs.vimPlugins; [ vim-airline ];
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  imports = [
    ./programs/alacritty.nix
    ./programs/i3.nix
  ];

  #services.gpg-agent = {
  #  enable = true;
  #  defaultCacheTtl = 1800;
  #  enableSshSupport = true;
  #};
}
