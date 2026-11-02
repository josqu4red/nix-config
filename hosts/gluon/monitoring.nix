{
  self,
  config,
  lib,
  ...
}:
let
  vmAddress = "127.0.0.1:8428";
in
{
  nxmods.impermanence.directories = [ "/var/lib/victoriametrics" ];

  nxmods.sops.secrets.ha.files."metrics/token".owner = "victoriametrics";

  sops.secrets."freebox-token" = {
    owner = "freebox-exporter";
    sopsFile = self.outPath + "/secrets/gluon/freebox.json";
    format = "json";
    key = "";
  };

  # systemd dynamic users do not support impermanence
  systemd.services.victoriametrics.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "victoriametrics";
    Group = "victoriametrics";
  };
  users.groups.victoriametrics = { };
  users.users.victoriametrics = {
    group = "victoriametrics";
    isSystemUser = true;
  };

  services.freebox-exporter = {
    enable = true;
    apiTokenFile = config.sops.secrets."freebox-token".path;
  };

  services.victoriametrics =
    let
      remove-port = [
        {
          source_labels = [ "__address__" ];
          regex = "(.+):\\d+";
          target_label = "instance";
          replacement = "$1";
        }
      ];
      set-hostname = [
        {
          target_label = "instance";
          replacement = config.networking.hostName;
        }
      ];
    in
    {
      enable = true;
      listenAddress = vmAddress;
      prometheusConfig.scrape_configs = [
        {
          job_name = "node-exporter";
          stream_parse = true;
          static_configs = [
            {
              targets = [
                "gluon:9100"
              ];
            }
          ];
          relabel_configs = remove-port;
        }
        {
          job_name = "bind-exporter";
          stream_parse = true;
          static_configs = [ { targets = [ "127.0.0.1:9119" ]; } ];
          relabel_configs = set-hostname;
        }
        {
          job_name = "freebox-exporter";
          stream_parse = true;
          static_configs = [ { targets = [ "127.0.0.1:9091" ]; } ];
          relabel_configs = set-hostname;
        }
        {
          job_name = "nextcloud-exporter";
          stream_parse = true;
          static_configs = [ { targets = [ "127.0.0.1:9205" ]; } ];
          relabel_configs = set-hostname;
        }
        {
          job_name = "ha";
          scrape_interval = "60s";
          metrics_path = "/api/prometheus";
          bearer_token_file = config.sops.secrets."ha/metrics/token".path;
          static_configs = [ { targets = [ "127.0.0.1:8123" ]; } ];
          relabel_configs = set-hostname;
          metric_relabel_configs = [
            {
              "if" = ''{__name__=~"ha_state_change_.*"}'';
              action = "drop";
            }
          ];
        }
      ];
    };

  services.grafana.provision = {
    enable = true;
    datasources.settings.datasources = [
      {
        name = "victoriametrics";
        type = "prometheus";
        url = "http://${vmAddress}";
      }
    ];
  };
}
