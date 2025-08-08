{ self, config, ... }: let
  dataDir = "/var/lib/cloud/paperless";
  hostName = "papers.amiez.xyz";
in {
  sops.secrets = let
    sopsFile = self.outPath + "/secrets/gluon/paperless.yaml";
  in {
    "paperless/adminpass" = {
      owner = "paperless";
      inherit sopsFile;
    };
    "paperless/backup/repo" = { inherit sopsFile; };
    "paperless/backup/env" = { inherit sopsFile; };
    "paperless/backup/password" = { inherit sopsFile; };
  };

  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."paperless/adminpass".path;
    inherit dataDir;
    settings = {
      PAPERLESS_URL = "https://${hostName}";
      PAPERLESS_OCR_LANGUAGE = "fra";
    };
  };

  services.nginx.virtualHosts.${hostName} = {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:28981";
      proxyWebsockets = true;
    };
  };

  services.restic.backups.paperless = let
    exportDir = "${dataDir}/export";
  in {
    initialize = true;
    repositoryFile = config.sops.secrets."paperless/backup/repo".path;
    environmentFile = config.sops.secrets."paperless/backup/env".path;
    passwordFile = config.sops.secrets."paperless/backup/password".path;
    paths = [ exportDir ];
    backupPrepareCommand = "${config.services.paperless.manage}/bin/paperless-manage document_exporter ${exportDir}";
  };
}
