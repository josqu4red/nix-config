{
  pkgs,
  lib,
  colors,
  defaultFont,
}:
let
  font = id: str: "%{T${id}}${str}%{T-}";
  padPct = "%percentage:3%%";
  transparentBg = "#cc" + lib.strings.removePrefix "#" colors.darker;
in
{
  enable = true;
  package = pkgs.polybarFull;
  script = "polybar -q -r top &";
  settings = {
    "bar/top" = {
      enable.ipc = true;
      modules.left = "i3";
      modules.center = "date";
      modules.right = "cpu battery backlight sound tray";
      font = [
        "${defaultFont}:size=12;4"
        "Noto Color Emoji:scale=10;4"
        "MaterialSymbolsSharp:size=14;4"
      ];
      separator = "%{F${colors.dark}}/%{F-}";
      background = transparentBg;
      foreground = colors.light;
      padding = 1;
      module.margin = 1;
      height = 30;
    };
    "module/backlight" = {
      type = "internal/backlight";
      enable-scroll = true;
      format = "<ramp>";
      ramp = [
        "🌑"
        "🌒"
        "🌓"
        "🌔"
        "🌕"
      ];
    };
    "module/battery" =
      let
        # MaterialSymbolsSharp ebdc ebd9 ebe0 ebdd ebe2 ebd4 ebd2 e1a4
        ramp = map (font "3") [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      in
      {
        type = "internal/battery";
        full-at = 98;
        format.charging = "<animation-charging><label-charging>";
        format.discharging = "<ramp-capacity><label-discharging>";
        format.full = "<ramp-capacity><label-full>";
        label-charging = padPct;
        label-discharging = padPct;
        label-full = padPct;
        ramp.capacity."0".foreground = colors.red;
        ramp.capacity.text = ramp;
        animation.charging.foreground = colors.green;
        animation.charging.framerate = 1000;
        animation.charging.text = ramp;
      };
    "module/cpu" = {
      type = "internal/cpu";
      format.text = "<ramp-coreload><label>";
      format.prefix.text = "󰓅"; # f04c5
      format.prefix.padding = 1;
      label = padPct;
      ramp.coreload.text = [
        "▁"
        "▂"
        "▃"
        "▄"
        "▅"
        "▆"
        "▇"
        "█"
      ];
      ramp.coreload.spacing = "1px";
    };
    "module/date" = {
      type = "internal/date";
      label = "%time%";
      time = "%H:%M:%S%";
      time-alt = "%Y-%m-%d";
    };
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
    "module/sound" = {
      type = "internal/pulseaudio";
      click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
      use-ui-max = false;
      interval = 1;
      format-volume = "<ramp-volume><label-volume>";
      format-muted = "<label-muted>";
      label-volume = padPct;
      label.muted = (font "3" "") + padPct; # e04f
      # MaterialSymbolsSharp e04e e04d e050
      ramp.volume.text = map (font "3") [
        ""
        ""
        ""
      ];
    };
    "module/tray".type = "internal/tray";
  };
}
