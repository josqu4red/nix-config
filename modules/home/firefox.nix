{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.firefox;
in {
  options.my.home.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    home.file.".mozilla/native-messaging-hosts/passff.json".source = "${pkgs.passff-host}/share/passff-host/passff.json";
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland.override {
        cfg.extraNativeMessagingHosts = [ pkgs.passff-host ];
      };
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
