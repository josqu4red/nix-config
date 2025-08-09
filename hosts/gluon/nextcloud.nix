{ self, config, lib, pkgs, ... }: let
  home = "/var/lib/cloud/nextcloud";
  hostName = "cloud.amiez.xyz";
  package = pkgs.nextcloud31;
in {
  sops.secrets = let
    sopsFile = self.outPath + "/secrets/gluon/nextcloud.yaml";
  in {
    "nextcloud/adminpass" = {
      owner = "nextcloud";
      restartUnits = [ "phpfpm-nextcloud.service" ];
      inherit sopsFile;
    };
    "nextcloud/backup/repo" = { inherit sopsFile; };
    "nextcloud/backup/env" = { inherit sopsFile; };
    "nextcloud/backup/password" = { inherit sopsFile; };
  };

  environment.systemPackages = [package];
  services.nextcloud = {
    enable = true;
    inherit home hostName package;
    https = true;
    config = {
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      dbtype = "sqlite";
    };
    settings = {
      default_phone_region = "FR";
      "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
      "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
      "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
    };
    extraAppsEnable = true;
    extraApps = with pkgs.nextcloud30Packages.apps; {
      inherit memories previewgenerator;
    };
  };

  systemd.services.nextcloud-cron.path = with pkgs; [ exiftool perl ];

  services.nginx.virtualHosts.${hostName} = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };

  services.restic.backups.nextcloud = let
    setMaintenance = s: "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --${s}";
  in {
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
  };
}
