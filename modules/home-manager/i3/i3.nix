{ lib, pkgs, defaultFont }: let
  inherit (lib) concatStringsSep;
  mod = "Mod4";
  floating = [ "nm-applet" "nm-connection-editor" ".blueman-manager-wrapped" "pavucontrol" "zoom" ]; # class
  # floating = [ "Bluetooth Devices" "Network Connections" "Volume Control" "Zoom Cloud Meetings" ]; # title
  rofi-drun = "${pkgs.rofi}/bin/rofi -show drun -modi drun";
  rofi-power = "${pkgs.rofi}/bin/rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
  pactl = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl";
  playerctl = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl";
  flameshot = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot";
  autorandr = "exec --no-startup-id ${pkgs.autorandr}/bin/autorandr";
in {
  enable = true;
  config = {
    modifier = mod;
    # Use Mouse+$mod to drag floating windows to their wanted position
    floating.modifier = mod;
    window = {
      border = 1;
      titlebar = false;
      commands = [
        { command = "floating enable"; criteria = { class = "(${concatStringsSep "|" floating})"; }; }
      ];
    };
    focus.followMouse = false;
    fonts = {
      names = [ defaultFont ];
      size = 13.0;
    };
    bars = [];
    keybindings = { # xmodmap -pke
      "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
      "${mod}+d" = ''exec "${rofi-drun} -theme-str 'window {width: 24em;}'"'';
      "${mod}+x" = ''exec "${rofi-power} -theme-str 'window {width: 12em;} listview {lines: 6;}'"'';
      "${mod}+Escape" = "kill";
      "${mod}+Shift+c" = "reload";
      "${mod}+Shift+r" = "restart";
      "${mod}+Shift+e" = "exit";
      "${mod}+Shift+x" = "exec ${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
      # modes
      "${mod}+r" = "mode resize";
      # change container layout
      "${mod}+q" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";
      # enter fullscreen mode for the focused container
      "${mod}+f" = "fullscreen toggle";
      # split container
      "${mod}+b" = "split h";
      "${mod}+v" = "split v";
      # focus the parent container
      "${mod}+a" = "focus parent";
      # focus the child container
      "${mod}+s" = "focus child";
      # change focus between tiling / floating windows
      "${mod}+space" = "focus mode_toggle";
      # toggle tiling / floating focus
      "${mod}+Shift+space" = "floating toggle";
      # change focus
      "${mod}+h" = "focus left";
      "${mod}+j" = "focus down";
      "${mod}+k" = "focus up";
      "${mod}+l" = "focus right";
      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";
      # move focused window
      "${mod}+Shift+H" = "move left";
      "${mod}+Shift+J" = "move down";
      "${mod}+Shift+K" = "move up";
      "${mod}+Shift+L" = "move right";
      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Right" = "move right";
      # workspaces
      "${mod}+1" = "workspace 1";
      "${mod}+2" = "workspace 2";
      "${mod}+3" = "workspace 3";
      "${mod}+4" = "scratchpad show";
      "${mod}+Shift+1" = "move container to workspace 1; workspace 1";
      "${mod}+Shift+2" = "move container to workspace 2; workspace 2";
      "${mod}+Shift+3" = "move container to workspace 3; workspace 3";
      "${mod}+Shift+4" = "move scratchpad";
      # multimedia
      "XF86AudioRaiseVolume"  = "${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume"  = "${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute"         = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioMicMute"      = "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
      "XF86Launch7"           = "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
      "XF86AudioPlay"         = "${playerctl} play-pause";
      "XF86AudioNext"         = "${playerctl} next";
      "XF86AudioPrev"         = "${playerctl} previous";
      "XF86MonBrightnessUp"   = "${brightnessctl} set 5%+";
      "XF86MonBrightnessDown" = "${brightnessctl} set 5%-";
      "XF86Display"           = "${autorandr} --change";
      "XF86Launch6"           = "${autorandr} --change";
      "Print"                 = "${flameshot} gui";
    };

    modes.resize = {
      "h" = "resize shrink width 10 px or 10 ppt";
      "j" = "resize grow height 10 px or 10 ppt";
      "k" = "resize shrink height 10 px or 10 ppt";
      "l" = "resize grow width 10 px or 10 ppt";
      "Return" = "mode default";
      "Escape" = "mode default";
    };

    startup = [
      {
        command = "systemctl --user restart polybar.service";
        always = true;
        notification = false;
      }
      {
        command = "${pkgs.feh}/bin/feh --no-fehbg --bg-scale --randomize ~/.local/share/backgrounds";
        always = true;
        notification = false;
      }
    ];
  };
}
