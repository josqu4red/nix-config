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

  services.vmagent = {
    enable = true;
    remoteWrite.url = "http://${vmAddress}/api/v1/write";
    prometheusConfig.scrape_configs = [
      {
        job_name = "node";
        stream_parse = true;
        static_configs = [ { targets = [ "${config.networking.hostName}:9100" ]; } ];
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
