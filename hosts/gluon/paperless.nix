# OIDC config
# kanidm group create paperless_users
# kanidm system oauth2 create paperless Paperasse-ngx https://papers.amiez.xyz
# kanidm system oauth2 add-redirect-url paperless https://papers.amiez.xyz/accounts/oidc/amiez/login/callback/
# kanidm system oauth2 update-scope-map paperless paperless_users openid email profile
# kanidm system oauth2 prefer-short-username paperless
# kanidm system oauth2 set-image paperless paperless-logo.svg

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
    "paperless/oauth2-config" = {
      owner = "paperless";
      inherit sopsFile;
    };
  };

  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."paperless/adminpass".path;
    environmentFile = config.sops.secrets."paperless/oauth2-config".path;
    inherit dataDir;
    settings = {
      PAPERLESS_URL = "https://${hostName}";
      PAPERLESS_OCR_LANGUAGE = "fra";
      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      PAPERLESS_ACCOUNT_DEFAULT_GROUPS = "users";
      PAPERLESS_ACCOUNT_EMAIL_VERIFICATION = "none";
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
