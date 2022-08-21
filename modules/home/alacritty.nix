{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.alacritty;
in {
  options.my.home.alacritty = {
    enable = mkEnableOption "alacritty";
  };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window.title = "Term";
        font = {
          normal.family = "JetBrainsMono Nerd Font";
          size = 12.0;
        };
      };
    };
  };
}
