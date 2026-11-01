{
  config,
  lib,
  pkgs,
  ...
}:
let
  home = "/var/lib/cloud/nextcloud";
  hostName = "cloud.amiez.xyz";
  origin = "https://" + hostName;
  ncVer = "nextcloud34";
  package = pkgs.${ncVer};
  inherit (pkgs."${ncVer}Packages") apps;
in
{
  nxmods.sops.secrets.nextcloud.files = {
    adminpass = {
      owner = "nextcloud";
      restartUnits = [ "phpfpm-nextcloud.service" ];
    };
    "metrics/token" = {
      owner = "nextcloud-exporter";
      restartUnits = [ "prometheus-nextcloud-exporter.service" ];
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
        collectives
        contacts
        deck
        groupfolders
        integration_paperless
        memories
        news
        notes
        previewgenerator
        tasks
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
      # nextcloud-occ user_oidc:provider demoprovider --clientid="WBXCa003871" \
      #   --clientsecret="lbXy***********" --discoveryuri="https://accounts.example.com/openid-configuration"
      # disable other auth methods:
      # nextcloud-occ config:app:set --value=0 user_oidc allow_multiple_user_backends
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

  nxmods.dns.aliases = [ "cloud" ];
  services.nginx.virtualHosts.${hostName} = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };

  nxmods.backup.jobs.nextcloud =
    let
      setMaintenance = s: "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --${s}";
    in
    {
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

  services.prometheus.exporters.nextcloud = {
    enable = true;
    url = origin;
    tokenFile = config.sops.secrets."nextcloud/metrics/token".path;
  };
}
