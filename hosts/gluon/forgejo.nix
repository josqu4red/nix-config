{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  dataDir = "/var/lib/cloud/forgejo";
  hostName = "git.amiez.xyz";
  HTTP_ADDR = "127.0.0.1";
  HTTP_PORT = 3001;
  forgejo-cli =
    let
      cfg = config.services.forgejo;
    in
    pkgs.writeShellScriptBin "forgejo-cli" ''
      exec /run/wrappers/bin/sudo FORGEJO_WORK_DIR=${cfg.stateDir} -u ${cfg.user} -g ${cfg.group} \
        ${lib.getExe cfg.package} "$@"
    '';
in
{
  nxmods.dns.aliases = [ "git" ];
  services.nginx.virtualHosts.${hostName} =
    self.lib.proxyVhost {
      upstream = "http://${HTTP_ADDR}:${toString HTTP_PORT}";
    }
    // {
      extraConfig = "client_max_body_size 0;";
    };

  # forgejo-cli admin auth add-oauth --name id.amiez.xyz --provider openidConnect --key forgejo \
  # --scopes "openid email profile ssh_publickeys" --attribute-ssh-public-key ssh_publickeys \
  # --auto-discover-url https://id.amiez.xyz/oauth2/openid/forgejo/.well-known/openid-configuration \
  # --group-team-map-removal --quota-group-map-removal --skip-local-2fa --secret <secret>
  services.kanidm.provision = {
    groups.forgejo_users.overwriteMembers = false;
    systems.oauth2.forgejo = {
      displayName = "Forgejo";
      imageFile = ./forgejo-logo.svg;
      originLanding = "https://${hostName}/";
      originUrl = "https://${hostName}/user/oauth2/id.amiez.xyz/callback";
      preferShortUsername = true;
      scopeMaps.forgejo_users = [
        "openid"
        "email"
        "profile"
        "ssh_publickeys"
      ];
    };
  };

  users = {
    groups.git = { };
    users.git = {
      home = dataDir;
      useDefaultShell = true;
      group = "git";
      isSystemUser = true;
    };
  };

  services.forgejo = {
    enable = true;
    stateDir = dataDir;
    user = "git";
    group = "git";
    settings = {
      # https://forgejo.org/docs/latest/admin/config-cheat-sheet/
      actions.ENABLED = true;
      log.LEVEL = "Warn";
      oauth2_client.ENABLE_AUTO_REGISTRATION = true;
      repository.DEFAULT_REPO_UNITS = "repo.code,repo.releases,repo.pulls,repo.packages,repo.actions";
      security.INSTALL_LOCK = true;
      service = {
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        ENABLE_BASIC_AUTHENTICATION = false;
        SHOW_REGISTRATION_BUTTON = false;
      };
      session.COOKIE_SECURE = true;
      server = {
        inherit HTTP_ADDR HTTP_PORT;
        DOMAIN = hostName;
        SSH_DOMAIN = hostName;
        ROOT_URL = "https://${hostName}/";
      };
    };
  };

  environment.systemPackages = [ forgejo-cli ];

  nxmods.backup.jobs.forgejo =
    let
      systemctl = "${config.systemd.package}/bin/systemctl";
    in
    {
      paths = [ dataDir ];
      backupPrepareCommand = "${systemctl} stop forgejo";
      backupCleanupCommand = "${systemctl} start forgejo";
      pruneOpts = [
        "--keep-daily 14"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
    };
}
