{ ... }: {
  programs.kitty = {
    enable = true;
    theme = "Nord";
    settings = {
      enable_audio_bell = "no";
      bell_on_tab = "󰗖";
      font_size = "12.0";
      tab_bar_style = "powerline";
      active_tab_foreground = "#4c566a";
      active_tab_background = "#88C0D0";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#D8DEE9";
      inactive_tab_background = "#4c566a";
      inactive_tab_font_style = "normal";
    };
  };
}
