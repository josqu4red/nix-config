{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.services.freebox-exporter;
  user = "freebox-exporter";
in {
  options.services.freebox-exporter = with types; {
    enable = mkEnableOption "freebox-exporter service";
    apiTokenFile = mkOption {
      type = str;
      example = [ "/etc/token.json" ];
      description = "Credentials file to access Freebox API";
    };
    listenAddress = mkOption {
      type = str;
      default = "127.0.0.1";
      description = "Address to bind to";
    };
    port = mkOption {
      type = int;
      default = 9091;
      description = "Port to listen to";
    };
  };

  config = mkIf cfg.enable {
    users.groups.${user} = {};
    users.users.${user} = {
      isSystemUser = true;
      group = user;
    };
    systemd.services.freebox-exporter = {
      description = "Prometheus exporter for the Freebox";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = user;
        Group = user;
        ExecStart = ''
          ${pkgs.freebox-exporter}/bin/freebox-exporter \
            -listen ${cfg.listenAddress}:${toString cfg.port} \
            ${cfg.apiTokenFile}
        '';
      };
    };
  };
}
