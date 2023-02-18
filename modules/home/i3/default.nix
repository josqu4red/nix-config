{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.i3;
  defaultFont = "JetBrainsMono Nerd Font";
  colors = import ./nord.nix { inherit lib; };
in {
  options.my.home.i3 = {
    enable = mkEnableOption "i3";
  };
  config = mkIf cfg.enable {
    xsession.enable = true; # to create tray.target
    services.picom.enable = true;
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;
    services.udiskie = {
      enable = true;
      automount = false;
    };
    services.polybar = import ./polybar.nix { inherit pkgs colors defaultFont; };
    services.dunst = import ./dunst.nix { inherit pkgs colors defaultFont; };
    programs.rofi = import ./rofi.nix { inherit pkgs; };
    xsession.windowManager.i3 = import ./i3.nix { inherit lib pkgs defaultFont; };
  };
}
