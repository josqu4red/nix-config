{ pkgs, ... }:
{
  programs.alacritty = {
    enable = false;

    settings = {
      font = {
        normal.family = "JetbrainsMono";
        size = 14.0;
      };
    };
  };
}
