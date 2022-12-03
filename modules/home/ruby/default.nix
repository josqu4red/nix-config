{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.ruby;
in {
  options.my.home.ruby = {
    enable = mkEnableOption "ruby";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.ruby ];
    home.file = {
      ".gemrc".source = ./gemrc;
      ".irbrc".source = ./irbrc;
    };
  };
}
