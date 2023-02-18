{ pkgs, colors, defaultFont }: let
  dunstColors = {
    background = colors.darker;
    foreground = colors.light;
  };
in {
  enable = true;
  settings = {
    global = {
      origin = "bottom-right";
      corner_radius = 2;
      font = defaultFont;
      frame_width = 2;
      frame_color = colors.cyan;
      separator_color = "frame";
    };
    urgency_normal = dunstColors;
    urgency_low = dunstColors;
    urgency_critical = dunstColors // { frame_color = colors.orange; };
  };
  iconTheme = {
    name = "material-design";
    package = pkgs.material-design-icons;
    size = "32x32";
  };
}
