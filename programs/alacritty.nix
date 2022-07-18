{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetbrainsMono";
        size = 12.0;
      };
    };
  };
}
