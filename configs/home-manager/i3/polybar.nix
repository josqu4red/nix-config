{ pkgs, colors, defaultFont }: {
  enable = true;
  package = pkgs.polybarFull;
  script = "polybar -q -r top &";
  settings = {
    "bar/top" = {
      enable.ipc = true;
      modules.left = "i3";
      modules.center = "date";
      modules.right = "cpu memory battery backlight sound";
      font = [ "${defaultFont}:size=16;4" ];
      separator = ""; # f444
      background = colors.darker;
      foreground = colors.light;
      padding = 1;
      module.margin = 1;
      height = 30;
      tray.position = "right";
    };
    "module/battery".type = "internal/battery";
    "module/i3" = {
      type = "internal/i3";
      show.urgent = true;
      label.focused.text = "󰮕"; # f0b95
      label.focused.padding = 1;
      label.unfocused.text = "󰝦"; # f0766
      label.unfocused.padding = 1;
      label.urgent.text = "󰗖"; # f05d6
      label.urgent.padding = 1;
    };
    "module/backlight" = {
      type = "internal/backlight";
      card = "intel_backlight";
      format = "<ramp>";
      ramp = [ "🌕" "🌔" "🌓" "🌒" "🌑" ];
    };
    "module/cpu" = {
      type = "internal/cpu";
      format.text = "<ramp-coreload><label>";
      format.suffix.text = "%{T10}󰓅%{T-}"; # f04c5
      format.suffix.padding = 1;
      label = "%percentage:3%%";
      ramp.coreload.text = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
      ramp.coreload.spacing = "1px";
    };
    "module/memory" = {
      type = "internal/memory";
      format.text = "<label>";
      format.suffix.text = "%{T10}󰍛%{T-}"; # f035b
      format.suffix.padding = 1;
      label = "%percentage_used:3%%";
    };
    "module/date" = {
      type = "internal/date";
      label = "%time%";
      time = "%H:%M:%S%";
      time-alt = "%Y-%m-%d";
    };
    "module/sound" = {
      type = "internal/pulseaudio";
      use-ui-max = false;
      interval = 1;
      format-volume = "<ramp-volume> <label-volume>";
      label-volume = "%percentage%%";
      ramp-volume-0 = "󰕿"; # f057f
      ramp-volume-1 = "󰖀"; # f0580
      ramp-volume-2 = "󰕾"; # f057e
      format-muted = "<label-muted>";
      label-muted = "󰸈 %percentage%%"; # f0e08
      click-right = "pavucontrol";
      # "󰍬" "󰍭"
    };
  };
}
