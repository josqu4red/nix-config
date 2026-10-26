{ self, config, ... }:
let
  dataDir = "/var/lib/cloud/paperless";
  hostName = "papers.amiez.xyz";
in
{
  services.kanidm.provision = {
    groups.paperless_users.overwriteMembers = false;
    systems.oauth2.paperless = {
      displayName = "Paperasse-ngx";
      imageFile = ./paperless-logo.svg;
      originLanding = "https://${hostName}";
      originUrl = "https://${hostName}/accounts/oidc/amiez/login/callback/";
      preferShortUsername = true;
      scopeMaps.paperless_users = [
        "openid"
        "email"
        "profile"
      ];
    };
  };

  nxmods.sops.secrets.paperless = {
    owner = "paperless";
    files.adminpass = { };
    files.oauth2-config = { };
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

  services.nginx.virtualHosts.${hostName} = self.lib.proxyVhost {
    upstream = "http://127.0.0.1:28981";
  };

  nxmods.backup.jobs.paperless =
    let
      exportDir = "${dataDir}/export";
    in
    {
      paths = [ exportDir ];
      backupPrepareCommand = "${config.services.paperless.manage}/bin/paperless-manage document_exporter ${exportDir}";
      pruneOpts = [
        "--keep-daily 14"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
    };
}
