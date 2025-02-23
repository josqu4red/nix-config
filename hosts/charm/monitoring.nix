{ self, config, ... }: let
  grafanaPort = 3000;
  vmPort = 8428;
  vmAddress = "${config.networking.hostName}:${toString vmPort}";
in {
  nxmods.impermanence.directories = [
    "/var/lib/grafana"
    "/var/lib/private/victoriametrics"
  ];

  services.victoriametrics = {
    enable = true;
    listenAddress = "0.0.0.0:${toString vmPort}";
  };

  users.groups.vmagent = {};
  users.users.vmagent = {
    group = "vmagent";
    isSystemUser = true;
  };
  sops.secrets."ha/metrics/token" = {
    owner = "vmagent";
    sopsFile = self.outPath + "/secrets/charm/ha.yaml";
  };

  services.vmagent = let
    instanceLabel = {
      relabel_configs = [{
        target_label = "instance";
        replacement = config.networking.hostName;
      }];
    };
    scrape_configs = map (sc: sc // instanceLabel) [
      {
        job_name = "node-exporter";
        stream_parse = true;
        static_configs = [ { targets = [ "127.0.0.1:9100" ]; } ];
      }
      {
        job_name = "freebox-exporter";
        stream_parse = true;
        static_configs = [ { targets = [ "127.0.0.1:9091" ]; } ];
      }
      {
        job_name = "ha";
        scrape_interval = "60s";
        metrics_path = "/api/prometheus";
        bearer_token_file = config.sops.secrets."ha/metrics/token".path;
        static_configs = [ { targets = [ "127.0.0.1:8123" ]; } ];
        metric_relabel_configs = [{
          "if" = ''{__name__=~"ha_state_change_.*"}'';
          action = "drop";
        }];
      }
    ];
  in {
    enable = true;
    remoteWrite.url = "http://${vmAddress}/api/v1/write";
    prometheusConfig = { inherit scrape_configs; };
  };

  services.grafana = {
    enable = true;
    settings = {
      server.http_addr = "0.0.0.0";
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [{
        name = "victoriametrics";
        type = "prometheus";
        url = "http://${vmAddress}";
      }];
    };
  };
  networking.firewall.allowedTCPPorts = [grafanaPort vmPort];
}
