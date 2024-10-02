{ self, lib, pkgs, ... }: {
  environment.persistence."/persist".directories = [ "/var/lib/hass" ];

  networking.firewall.allowedUDPPorts = [ 1900 5353 ]; # ssdp mdns

  services.nginx = {
    virtualHosts."ha.amiez.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://ha";
        proxyWebsockets = true;
      };
    };
    virtualHosts."ha.in.amiez.xyz".locations."/" = {
      proxyPass = "http://ha";
      proxyWebsockets = true;
    };
    upstreams.ha.servers."127.0.0.1:8123" = {};
  };

  nxmods.sops.enable = true;
  sops.secrets.ha-secrets = {
    sopsFile = self.outPath + "/secrets/charm/ha.yaml";
    owner = "hass";
    path = "/var/lib/hass/secrets.yaml";
    restartUnits = [ "home-assistant.service" ];
  };

  services.home-assistant = {
    enable = true;
    extraPackages = pypkgs: with pypkgs; [ gtts radios ];
    config = {
      homeassistant = {
        name = "Home";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        time_zone = "Europe/Paris";
      };

      http = {
        use_x_forwarded_for = true;
        server_host = "127.0.0.1";
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };

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
