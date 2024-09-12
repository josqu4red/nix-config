{ inputs, pkgs, ... }: let
  firefox-addons = inputs.firefox-addons.packages."${pkgs.system}";
in {
  programs.firefox = {
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
      extensions = with firefox-addons; [ tabcenter-reborn ];
    };
  };
}
