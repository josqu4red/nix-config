{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.firefox;
in {
  options.my.home.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles."default" = {
        userChrome = ''
          #TabsToolbar {
            visibility: collapse;
          }
          #sidebar-header {
            visibility: collapse !important;
          }
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
