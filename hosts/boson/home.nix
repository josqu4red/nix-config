{ config, pkgs, ... }: {
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ nvd spotify ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  imports = [
    ../../programs/alacritty.nix
    ../../programs/firefox.nix
    ../../programs/i3.nix
    ../../programs/pass.nix
    ../../programs/polybar.nix
    ../../programs/tmux.nix
    ../../programs/vim.nix
  ];

  #services.gpg-agent = {
  #  enable = true;
  #  defaultCacheTtl = 1800;
  #  enableSshSupport = true;
  #};
}
