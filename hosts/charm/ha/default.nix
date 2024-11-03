{ self, config, lib, pkgs, ... }: let
  homeDir = "/var/lib/hass";
in {
  nxmods = {
    impermanence.directories = [ homeDir ];
    sops.enable = true;
  };

  networking.firewall.allowedUDPPorts = [ 1900 5353 ]; # ssdp mdns

  sops.secrets = let
    sopsFile = self.outPath + "/secrets/charm/ha.yaml";
  in {
    "ha/secrets" = {
      inherit sopsFile;
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";
      restartUnits = [ "home-assistant.service" ];
    };
    "ha/backup/repo" = { inherit sopsFile; };
    "ha/backup/env" = { inherit sopsFile; };
    "ha/backup/password" = { inherit sopsFile; };
  };

  services.restic.backups.ha = {
    initialize = true;
    repositoryFile = config.sops.secrets."ha/backup/repo".path;
    environmentFile = config.sops.secrets."ha/backup/env".path;
    passwordFile = config.sops.secrets."ha/backup/password".path;
    paths = [ homeDir ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-hourly 3"
      "--keep-daily 14"
    ];
  };

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

  services.home-assistant = let
    inherit (lib) listToAttrs mergeAttrsList nameValuePair;
    mkInclude = type: name: { "${name} ui" = "!include ${name}s.yaml"; "${name} manual" = "!include_dir_${type} ${./${name}s}"; };

    simpleIntegrations = [ "bluetooth" "config" "dhcp" "energy" "history" "homeassistant_alerts" "isal" "logbook"
                           "media_source" "mobile_app" "my" "ssdp" "stream" "sun" "usb" "zeroconf" "zha" ];
    extraComponents = [ "androidtv_remote" "cast" "dlna_dmr" "dlna_dms" "esphome" "freebox" "group"
                        "meteo_france" "mqtt" "sonos" "update" "upnp" ];
    customComponents = with pkgs; [ hacs-espsomfyrts hacs-rtetempo ];
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [ mini-graph-card mushroom ];
  in {
    enable = true;
    extraPackages = pypkgs: with pypkgs; [ gtts radios ];
    inherit customComponents customLovelaceModules extraComponents;
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

      frontend = { themes = "!include ${./themes.yaml}"; };
      scene = "!include scenes.yaml";
      script = "!include scripts.yaml";
      template = "!include templates.yaml";
      panel_custom = import ./shortcuts.nix {};
    } // listToAttrs (map (x: nameValuePair x {}) simpleIntegrations)
      // mergeAttrsList [ (mkInclude "list" "automation") ];
  };
}
