{
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultFont = "JetBrainsMono Nerd Font";
  colors = import ./nord.nix { inherit lib; };
  lock = "${pkgs.swaylock-effects}/bin/swaylock -f";
  # graphical-session.target is reached before sway exports WAYLAND_DISPLAY,
  # so GUI services must wait for sway-session.target instead
  late = lib.genAttrs [
    "polkit-gnome"
    "network-manager-applet"
    "udiskie"
  ] (_: {
    Unit = {
      After = lib.mkForce [
        "sway-session.target"
        "tray.target"
      ];
      PartOf = lib.mkForce [ "sway-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "sway-session.target" ];
  });
in
{
  home.packages = with pkgs; [
    material-symbols
    noto-fonts-color-emoji
    wl-clipboard
  ];
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Screenshots
    early_exit=true
  '';
  wayland.systemd.target = "sway-session.target";
  systemd.user.services =
    late
    // lib.optionalAttrs config.services.nextcloud-client.enable {
      nextcloud-client = late.polkit-gnome;
    };

  wayland.windowManager.sway = {
    enable = true;
    # session, GL and PAM come from the system (nxmods.desktop.sway);
    # on a non-NixOS distro use its sway or a nixGL-wrapped package
    package = lib.mkDefault null;
    wrapperFeatures.gtk = true;
  }
  // import ./config.nix { inherit lib pkgs defaultFont; };

  services.polkit-gnome.enable = true;
  # secrets only: gpg-agent owns SSH
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };
  services.network-manager-applet.enable = true;
  services.blueman-applet = {
    enable = true;
    systemdTargets = [ "sway-session.target" ];
  };
  services.udiskie = {
    enable = true;
    automount = false;
  };
  services.dunst = import ./dunst.nix { inherit pkgs colors defaultFont; };
  programs.rofi = import ./rofi.nix { inherit pkgs; };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # blurred, dimmed screenshot with a clock inside the ring
      screenshots = true;
      effect-blur = "9x5";
      effect-vignette = "0.4:0.6";
      fade-in = 0.2;
      clock = true;
      indicator = true;
      indicator-radius = 110;
      indicator-thickness = 8;
      font = defaultFont;
      show-failed-attempts = true;
      color = lib.removePrefix "#" colors.darker;
      inside-color = "${lib.removePrefix "#" colors.darker}cc";
      ring-color = lib.removePrefix "#" colors.grey;
      key-hl-color = lib.removePrefix "#" colors.cyan;
      bs-hl-color = lib.removePrefix "#" colors.orange;
      ring-ver-color = lib.removePrefix "#" colors.cyan;
      inside-ver-color = "${lib.removePrefix "#" colors.darker}cc";
      ring-wrong-color = lib.removePrefix "#" colors.red;
      inside-wrong-color = "${lib.removePrefix "#" colors.darker}cc";
      line-color = "00000000";
      separator-color = "00000000";
      text-color = lib.removePrefix "#" colors.light;
    };
  };
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = lock;
      }
      {
        timeout = 1200;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = {
      before-sleep = lock;
      lock = lock;
    };
  };

  # ponytail: output names only; match by EDID description if two externals ever clash
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1200";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1200";
            position = "760,1440";
          }
          {
            criteria = "*";
            mode = "3440x1440";
            position = "0,0";
          }
        ];
      }
    ];
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      height = 30;
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "privacy"
        "cpu"
        "battery"
        "backlight"
        "pulseaudio"
        "tray"
      ];
      clock = {
        format = "{:%H:%M:%S}";
        format-alt = "{:%Y-%m-%d}";
        interval = 1;
      };
      cpu.format = "󰓅 {usage}%";
      battery = {
        format = "{icon} {capacity}%";
        format-icons = [
          "󰁺"
          "󰁼"
          "󰁾"
          "󰂀"
          "󰁹"
        ];
        format-charging = "󰂄 {capacity}%";
      };
      backlight = {
        format = "{icon}";
        format-icons = [
          "🌑"
          "🌒"
          "🌓"
          "🌔"
          "🌕"
        ];
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons.default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
        on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      privacy.icon-spacing = 8; # mic, camera and screen-share indicators via PipeWire
      tray.spacing = 8;
    };
    style = ''
      * { font-family: "${defaultFont}", "Noto Color Emoji"; font-size: 14px; }
      window#waybar { background: alpha(${colors.darker}, 0.8); color: ${colors.light}; }
      #workspaces button { color: ${colors.light}; padding: 0 8px; }
      #workspaces button.focused { color: ${colors.cyan}; }
      #workspaces button.urgent { color: ${colors.orange}; }
      #privacy, #cpu, #battery, #backlight, #pulseaudio, #clock, #tray { padding: 0 10px; }
      #battery.critical:not(.charging) { color: ${colors.red}; }
      #privacy-item.audio-in, #privacy-item.video-in { color: ${colors.orange}; }
      #battery.charging { color: ${colors.green}; }
    '';
  };
}
