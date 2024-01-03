{ lib, pkgs, ... }:
let
  inherit (builtins) readDir;
  inherit (lib) filterAttrs mapAttrs' nameValuePair;
  # TODO: move to shared lib, use in zsh
  xdgFilesFromDir = target: path:
    let files = filterAttrs (n: v: v == "regular") (readDir path);
    in mapAttrs' (k: v: nameValuePair "${target}/${k}" { source = "${path}/${k}"; }) files;

  defaultFont = "JetBrainsMono Nerd Font";
  colors = import ./nord.nix { inherit lib; };
in {
  home.packages = with pkgs; [ material-symbols noto-fonts-color-emoji ];
  xdg.dataFile = xdgFilesFromDir "backgrounds" ./walls;
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
  services.xidlehook = {
    enable = true;
    detect-sleep = true;
    not-when-fullscreen = true;
    timers = [
      { delay = 120; command = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim"; }
      { delay = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
