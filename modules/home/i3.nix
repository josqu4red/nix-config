{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.i3;
  mod = "Mod4";
  exitMode = "Exit: [l]ogout [h]ibernate [r]eboot [s]hutdown";
in {
  options.my.home.i3 = {
    enable = mkEnableOption "i3";
  };
  config = mkIf cfg.enable {
    programs.rofi.enable = true;
    home.packages = [ pkgs.feh ];

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        bars = [];
        modifier = mod;
        # Use Mouse+$mod to drag floating windows to their wanted position
        floating.modifier = mod;
        window.border = 1;
        focus.followMouse = false;
        fonts.names = ["JetBrainsMono Nerd Font"];

        keybindings = lib.mkOptionDefault {
          "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
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
          # change focus between tiling / floating windows
          "${mod}+space" = "focus mode_toggle";
          # focus the parent container
          #"${mod}+q" = "focus parent";
          # focus the child container
          #"${mod}+d" = "focus child";
          # move focused window
          "${mod}+Shift+H" = "move left";
          "${mod}+Shift+J" = "move down";
          "${mod}+Shift+K" = "move up";
          "${mod}+Shift+L" = "move right";
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
          "${mod}+ampersand" = "workspace 1";
          "${mod}+eacute" = "workspace 2";
          "${mod}+quotedbl" = "workspace 3";
          "${mod}+apostrophe" = "workspace 4";
          "${mod}+parenleft" = "workspace 5";
          "${mod}+minus" = "workspace 6";
          "${mod}+parenright" = "workspace prev";
          "${mod}+equal" = "workspace next";
          "${mod}+Shift+1" = "move container to workspace 1; workspace 1";
          "${mod}+Shift+2" = "move container to workspace 2; workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3; workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4; workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5; workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6; workspace 6";
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
          "h" = "exec systemctl hibernate";
          "r" = "exec systemctl reboot";
          "s" = "exec systemctl shutdown";
          "Return" = "mode default";
          "Escape" = "mode default";
        };

        startup = [
          {
            command = "exec --no-startup-id i3-msg workspace 1";
            always = true;
            notification = false;
          }
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
    };
  };
}

#bindsym F9 exec /etc/i3/lock
#
#bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume $(pactl info | awk '/Default Sink/ {print $NF}') +10%
#bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume $(pactl info | awk '/Default Sink/ {print $NF}') -10%
#bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute $(pactl info | awk '/Default Sink/ {print $NF}') toggle
