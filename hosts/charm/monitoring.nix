{ self, config, ... }: let
  publicHostname = "graf.in.amiez.xyz";
  vmAddress = "127.0.0.1:8428";
in {
  nxmods.impermanence.directories = [
    "/var/lib/grafana"
    "/var/lib/private/victoriametrics"
  ];

  users.groups.victoriametrics = {};
  users.users.victoriametrics = {
    group = "victoriametrics";
    isSystemUser = true;
  };
  sops.secrets."ha/metrics/token" = {
    owner = "victoriametrics";
    sopsFile = self.outPath + "/secrets/charm/ha.yaml";
  };

  services.victoriametrics = let
    remove-port = [{
      source_labels = ["__address__"];
      regex = "(.+):\\d+";
      target_label = "instance";
      replacement = "$1";
    }];
    set-hostname = [{
      target_label = "instance";
      replacement = config.networking.hostName;
    }];
  in {
    enable = true;
    listenAddress = vmAddress;
    prometheusConfig.scrape_configs = [
      {
        job_name = "node-exporter";
        stream_parse = true;
        static_configs = [ { targets = [ "charm:9100" "gluon:9100" ]; } ];
        relabel_configs = remove-port;
      }
      {
        job_name = "freebox-exporter";
        stream_parse = true;
        static_configs = [ { targets = [ "127.0.0.1:9091" ]; } ];
        relabel_configs = set-hostname;
      }
      {
        job_name = "ha";
        scrape_interval = "60s";
        metrics_path = "/api/prometheus";
        bearer_token_file = config.sops.secrets."ha/metrics/token".path;
        static_configs = [ { targets = [ "127.0.0.1:8123" ]; } ];
        relabel_configs = set-hostname;
        metric_relabel_configs = [{
          "if" = ''{__name__=~"ha_state_change_.*"}'';
          action = "drop";
        }];
      }
    ];
  };

  services.nginx = {
    virtualHosts.${publicHostname} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
        extraConfig = let
          subnet = with config.facts.homeNet.prefix; "${address}/${builtins.toString length}";
        in ''
          allow ${subnet};
          deny all;
        '';
      };
    };
  };

  services.grafana = {
    enable = true;
    settings.server.domain = publicHostname;
    provision = {
      enable = true;
      datasources.settings.datasources = [{
        name = "victoriametrics";
        type = "prometheus";
        url = "http://${vmAddress}";
      }];
    };
  };
}
