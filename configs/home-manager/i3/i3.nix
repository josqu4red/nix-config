{ lib, pkgs, defaultFont }: let
  inherit (lib) concatStringsSep;
  mod = "Mod4";
  exitMode = "Exit: [l]ogout [s]uspend [r]eboot [p]oweroff";
  floating = [ "Bluetooth Devices" "Network Connections" ];
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
        { command = "floating enable"; criteria = { title = "(${concatStringsSep "|" floating})"; }; }
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
      "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun -modi drun";
      # modes
      "${mod}+r" = "mode resize";
      "${mod}+x" = "mode ${exitMode}";
      # actions
      #"${$mod}+Shift+A" = "kill";
      "${mod}+Shift+c" = "reload";
      "${mod}+Shift+r" = "restart";
      "${mod}+Shift+e" = "exit";
      # change focus
      "${mod}+h" = "focus left";
      "${mod}+j" = "focus down";
      "${mod}+k" = "focus up";
      "${mod}+l" = "focus right";
      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";
      # change focus between tiling / floating windows
      "${mod}+space" = "focus mode_toggle";
      # focus the parent container
      "${mod}+q" = "focus parent";
      # focus the child container
      "${mod}+a" = "focus child";
      # move focused window
      "${mod}+Shift+H" = "move left";
      "${mod}+Shift+J" = "move down";
      "${mod}+Shift+K" = "move up";
      "${mod}+Shift+L" = "move right";
      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Right" = "move right";
      # toggle tiling / floating focus
      "${mod}+Shift+space" = "floating toggle";
      # split in horizontal orientation
      "${mod}+b" = "split h";
      # split in vertical orientation
      "${mod}+v" = "split v";
      # enter fullscreen mode for the focused container
      "${mod}+f" = "fullscreen toggle";
      # change container layout (stacked, tabbed, toggle split)
      "${mod}+s" = "layout stacking";
      "${mod}+z" = "layout tabbed";
      "${mod}+e" = "layout toggle split";
      # workspaces
      "${mod}+1" = "workspace 1";
      "${mod}+2" = "workspace 2";
      "${mod}+3" = "workspace 3";
      "${mod}+4" = "workspace 4";
      "${mod}+Shift+exclam" = "move container to workspace 1; workspace 1";
      "${mod}+Shift+at" = "move container to workspace 2; workspace 2";
      "${mod}+Shift+numbersign" = "move container to workspace 3; workspace 3";
      "${mod}+Shift+dollar" = "move container to workspace 4; workspace 4";
      # multimedia
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
      "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
      "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
      "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
      "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
      "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10";
      "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10";
    };

    modes.resize = {
      "h" = "resize shrink width 10 px or 10 ppt";
      "j" = "resize grow height 10 px or 10 ppt";
      "k" = "resize shrink height 10 px or 10 ppt";
      "l" = "resize grow width 10 px or 10 ppt";
      "Return" = "mode default";
      "Escape" = "mode default";
    };

    modes."${exitMode}" = {
      "l" = "exec i3-msg exit";
      "s" = "exec systemctl suspend";
      "r" = "exec systemctl reboot";
      "p" = "exec systemctl poweroff";
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
        command = "${pkgs.feh}/bin/feh --bg-scale ~/.background.png";
        always = true;
        notification = false;
      }
    ];
  };
}
