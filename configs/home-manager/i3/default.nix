{ lib, pkgs, ... }:
let
  defaultFont = "JetBrainsMono Nerd Font";
  colors = import ./nord.nix { inherit lib; };
in {
  home.packages = with pkgs; [ material-symbols noto-fonts-color-emoji ];
  xsession.enable = true; # to create tray.target
  services.picom.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.udiskie = {
    enable = true;
    automount = false;
  };
  services.polybar = import ./polybar.nix { inherit pkgs lib colors defaultFont; };
  services.dunst = import ./dunst.nix { inherit pkgs colors defaultFont; };
  programs.rofi = import ./rofi.nix { inherit pkgs; };
  xsession.windowManager.i3 = import ./i3.nix { inherit lib pkgs defaultFont; };
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolock.extraOptions = [
      "-killtime 10"
      "-killer 'systemctl suspend'"
    ];
  };
}
