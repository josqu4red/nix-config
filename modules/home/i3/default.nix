{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.i3;
  mod = "Mod4";
  exitMode = "Exit: [l]ogout [s]uspend [r]eboot [p]oweroff";
in {
  options.my.home.i3 = {
    enable = mkEnableOption "i3";
  };
  config = mkIf cfg.enable {
    services.picom.enable = true;
    programs.rofi = {
      enable = true;
      theme = "solarized_alternate";
    };
    home.packages = [ pkgs.feh ];

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        # Use Mouse+$mod to drag floating windows to their wanted position
        floating.modifier = mod;
        window = {
          border = 1;
          titlebar = false;
        };
        focus.followMouse = false;
        fonts = {
          names = ["JetBrains Mono"];
          size = 13.0;
        };

        keybindings = {
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
          "${mod}+q" = "focus parent";
          # focus the child container
          "${mod}+a" = "focus child";
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
          "s" = "exec systemctl suspend";
          "r" = "exec systemctl reboot";
          "p" = "exec systemctl poweroff";
          "Return" = "mode default";
          "Escape" = "mode default";
        };

        startup = [
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
