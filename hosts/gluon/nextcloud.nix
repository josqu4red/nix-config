{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  home = "/var/lib/cloud/nextcloud";
  hostName = "cloud.amiez.xyz";
  origin = "https://" + hostName;
  ncVer = "nextcloud32";
  package = pkgs.${ncVer};
  apps = pkgs."${ncVer}Packages".apps;
in
{
  sops.secrets =
    let
      sopsFile = self.outPath + "/secrets/gluon/nextcloud.yaml";
    in
    {
      "nextcloud/adminpass" = {
        owner = "nextcloud";
        restartUnits = [ "phpfpm-nextcloud.service" ];
        inherit sopsFile;
      };
      "nextcloud/backup/repo" = { inherit sopsFile; };
      "nextcloud/backup/env" = { inherit sopsFile; };
      "nextcloud/backup/password" = { inherit sopsFile; };
      "nextcloud/metrics/token" = {
        owner = "nextcloud-exporter";
        restartUnits = [ "prometheus-nextcloud-exporter.service" ];
        inherit sopsFile;
      };
    };

  services.kanidm.provision = {
    groups.nextcloud_users.overwriteMembers = false;
    systems.oauth2.nextcloud = {
      displayName = "Nextcloud";
      imageFile = ./nextcloud-logo.svg;
      originLanding = origin;
      originUrl = origin + "/apps/user_oidc/code";
      preferShortUsername = true;
      scopeMaps.nextcloud_users = [
        "openid"
        "email"
        "profile"
        "nextcloud_groups"
      ];
      claimMaps.nextcloud_groups = {
        joinType = "array";
        valuesByGroup.nextcloud_users = [ "users" ];
      };
    };
  };

  environment.systemPackages = [ package ];
  services.nextcloud = {
    enable = true;
    inherit home hostName package;
    https = true;
    config = {
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      dbtype = "sqlite";
    };
    extraAppsEnable = true;
    extraApps = with apps; {
      inherit
        bookmarks
        calendar
        contacts
        deck
        integration_paperless
        memories
        news
        previewgenerator
        unroundedcorners
        user_oidc
        ;
    };
    settings = {
      "default_phone_region" = "FR";
      # memories
      "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
      "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
      "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
      # previewgenerator
      "preview_ffmpeg_path" = "${lib.getExe pkgs.ffmpeg-headless}";
      # user_oidc
      # https://kanidm.github.io/kanidm/master/integrations/oauth2/examples.html#nextcloud
      "allow_local_remote_servers" = true;
      "allow_user_to_change_display_name" = false;
      "allow_user_to_change_email" = false;
      "lost_password_link" = "disabled";
    };
  };

  systemd.services.nextcloud-cron.path = with pkgs; [
    exiftool
    perl
  ];

  services.nginx.virtualHosts.${hostName} = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };

  services.restic.backups.nextcloud =
    let
      setMaintenance = s: "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --${s}";
    in
    {
      initialize = true;
      repositoryFile = config.sops.secrets."nextcloud/backup/repo".path;
      environmentFile = config.sops.secrets."nextcloud/backup/env".path;
      passwordFile = config.sops.secrets."nextcloud/backup/password".path;
      paths = [ home ];
      exclude = [
        "data/appdata_*/preview"
        "data/*/cache"
        "data/*/uploads"
      ];
      backupPrepareCommand = setMaintenance "on";
      backupCleanupCommand = setMaintenance "off";
      pruneOpts = [
        "--keep-daily 14"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
    };

  networking.firewall.allowedTCPPorts = [ config.services.prometheus.exporters.nextcloud.port ];
  services.prometheus.exporters.nextcloud = {
    enable = true;
    url = origin;
    tokenFile = config.sops.secrets."nextcloud/metrics/token".path;
  };
}
