{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nxmods.backup;
in {
  options.nxmods.backup = {
    enable = mkEnableOption "Default system backup";
    paths = mkOption {
      type = with types; listOf path;
    };
  };
  config = mkIf cfg.enable {
    sops.secrets = {
      "backup/repo" = {};
      "backup/env" = {};
      "backup/password" = {};
    };

    services.restic.backups.system = {
      initialize = true;
      repositoryFile = config.sops.secrets."backup/repo".path;
      environmentFile = config.sops.secrets."backup/env".path;
      passwordFile = config.sops.secrets."backup/password".path;
      inherit (cfg) paths;
    };
  };
}
