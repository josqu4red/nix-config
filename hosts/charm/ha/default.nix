{ lib, pkgs, ... }: {
  environment.persistence."/persist".directories = [ "/var/lib/hass" ];

  networking.firewall.allowedUDPPorts = [ 1900 5353 ]; # ssdp mdns

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraPackages = pypkgs: with pypkgs; [ gtts radios ];
    config = {
      homeassistant = {
        name = "Home";
        #latitude = "!secret latitude";
        #longitude = "!secret longitude";
        #elevation = "!secret elevation";
        unit_system = "metric";
        time_zone = "Europe/Paris";
      };

      http = {};

      automation = "!include automations.yaml";
      frontend = { themes = "!include_dir_merge_named themes"; };
      scene = "!include scenes.yaml";
      script = "!include scripts.yaml";
      template = "!include templates.yaml";
      panel_custom = import ./shortcuts.nix {};

      backup = {};
      bluetooth = {};
      config = {};
      dhcp = {};
      energy = {};
      history = {};
      homeassistant_alerts = {};
      isal = {};
      logbook = {};
      media_source = {};
      mobile_app = {};
      my = {};
      ssdp = {};
      stream = {};
      sun = {};
      usb = {};
      zeroconf = {};
      zha = {};
    };
    extraComponents = [
      "androidtv_remote"
      "cast"
      "dlna_dmr"
      "dlna_dms"
      "esphome"
      "freebox"
      "group"
      "meteo_france"
      "mqtt"
      "sonos"
      "update"
      "upnp"
    ];
    customComponents = with pkgs; [ esprtsha ];
  };
}
