{
  inputs,
  config,
  pkgs,
  ...
}:
let
  firefox-addons = inputs.firefox-addons.packages."${pkgs.stdenv.hostPlatform.system}";
in
{
  programs.firefox = {
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    enable = true;
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
      extensions.packages = with firefox-addons; [ tabcenter-reborn ];
    };
  };
}
