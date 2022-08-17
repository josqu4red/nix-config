{ config, pkgs, ... }: {
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ spotify ];

  imports = import ../../modules/home;

  homeCfg = {
    alacritty.enable = true;
    firefox.enable = true;
    i3.enable = true;
    nix-tools.enable = true;
    pass.enable = true;
    polybar.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };
}
