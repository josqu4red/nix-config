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
  # https://github.com/nix-community/home-manager/issues/7708
  systemd.user.targets.hm-graphical-session.Unit.Requires = lib.mkForce [ "graphical-session-pre.target" ];

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
      { delay = 600; command = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim"; }
      { delay = 1200; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
  services.flameshot = import ./flameshot.nix { inherit colors; };
  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
        "notify-polybar" = "${pkgs.polybar}/bin/polybar-msg cmd restart";
      };
    };
    profiles = let
      eDP-1 = "00ffffffffffff000e8f121400000000001e0104a51e137803ee95a3544c99260f505400000001010101010101010101010101010101743c80a070b02840302036002dbc1000001a000000fd00303c4a4a0f010a202020202020000000fe0043544f0a202020202020202020000000fe004c454231343230314e0a2020200030";
      HDMI-1 = "00ffffffffffff0004693334010101010e1c0103805021780eee91a3544c99260f5054210800010101010101010101010101010101019d6770a0d0a0225030203a001d4d3100001a000000ff004a344c4d51533030353136390a000000fd00183c1e8c1e010a202020202020000000fc00524f47205047333438510a2020013402031ac147901f0413031201230907018301000065030c0010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c1";
      DP-2 = "*";
      laptop = {
        mode = "1920x1200";
        position = "760x1440";
        primary = true;
      };
      external = {
        mode = "3440x1440";
        position = "0x0";
      };
    in {
      laptop = {
        fingerprint = {
          inherit eDP-1;
        };
        config = {
          eDP-1 = laptop;
        };
      };
      home = {
        fingerprint = {
          inherit eDP-1 HDMI-1;
        };
        config = {
          eDP-1.enable = false;
          HDMI-1 = external // { primary = true; };
        };
      };
      office = {
        fingerprint = {
          inherit eDP-1 DP-2;
        };
        config = {
          eDP-1 = laptop;
          DP-2 = external;
        };
      };
    };
  };
}
