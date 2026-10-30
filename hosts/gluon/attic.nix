{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  dataDir = "/var/lib/cloud/attic";
  hostName = "cache.amiez.xyz";
  listen = "127.0.0.1:8180";
  cfg = config.services.atticd;
  configFile = builtins.elemAt (lib.splitString " " config.systemd.services.atticd.serviceConfig.ExecStart) 2;
  atticadm = pkgs.writeShellScriptBin "atticadm" ''
    # run as root: the env file holding the token secret is root-only
    exec env "$(${pkgs.coreutils}/bin/cat ${cfg.environmentFile})" \
      ${cfg.package}/bin/atticadm -f ${configFile} "$@"
  '';
in
{
  nxmods.sops.secrets.attic.files.env.restartUnits = [ "atticd.service" ];

  users.groups.atticd = { };
  users.users.atticd = {
    group = "atticd";
    home = dataDir;
    isSystemUser = true;
  };
  systemd.services.atticd.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "atticd";
    Group = "atticd";
    ReadWritePaths = [ dataDir ];
  };
  systemd.tmpfiles.rules = [ "d ${dataDir} 0750 atticd atticd -" ];

  environment.systemPackages = [ atticadm ];

  services.atticd = {
    enable = true;
    environmentFile = config.sops.secrets."attic/env".path;
    settings = {
      inherit listen;
      api-endpoint = "https://${hostName}/";
      database.url = "sqlite://${dataDir}/server.db?mode=rwc";
      storage = {
        type = "local";
        path = "${dataDir}/storage";
      };
      chunking = {
        nar-size-threshold = 64 * 1024;
        min-size = 16 * 1024;
        avg-size = 64 * 1024;
        max-size = 256 * 1024;
      };
    };
  };

  services.nginx.virtualHosts.${hostName} =
    self.lib.proxyVhost {
      upstream = "http://${listen}";
    }
    // {
      extraConfig = "client_max_body_size 0;";
    };
}
