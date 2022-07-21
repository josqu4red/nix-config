{ config, pkgs, ... }:
{
  home.stateVersion = "22.05";
  home.username = "jamiez";
  home.homeDirectory = "/home/jamiez";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nvd
    pass
    slack
    spotify
    zoom-us
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles."default" = {
      userChrome = ''
        #TabsToolbar {
          visibility: collapse;
        }
        #sidebar-header {
          visibility: collapse !important;
        }
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  #programs.vim = {
  #  plugins = with pkgs.vimPlugins; [ vim-airline ];
  #};

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  #imports = [
  #  ./programs/alacritty.nix
  #  ./programs/i3.nix
  #  ./programs/polybar.nix
  #];

  #services.gpg-agent = {
  #  enable = true;
  #  defaultCacheTtl = 1800;
  #  enableSshSupport = true;
  #};
}
