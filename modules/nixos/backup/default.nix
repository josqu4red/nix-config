{ config, lib, ... }:
let
  inherit (lib)
    genAttrs
    mapAttrs
    mkOption
    types
    ;
  cfg = config.nxmods.backup;
  keys = [
    "repo"
    "env"
    "password"
  ];
in
{
  options.nxmods.backup = {
    jobs = mkOption {
      type = with types; attrsOf (attrsOf anything);
      default = { };
      description = ''
        Restic jobs, passed through to `services.restic.backups`. Credentials
        come from the `<name>/backup/{repo,env,password}` keys of the `<name>`
        secret group.
      '';
    };
  };
  config = {
    nxmods.sops.secrets = mapAttrs (_: _: {
      files = genAttrs (map (k: "backup/${k}") keys) (_: {
        owner = null;
      });
    }) cfg.jobs;

    services.restic.backups = mapAttrs (
      name: job:
      let
        secret = k: config.sops.secrets."${name}/backup/${k}".path;
      in
      {
        initialize = true;
        repositoryFile = secret "repo";
        environmentFile = secret "env";
        passwordFile = secret "password";
      }
      // job
    ) cfg.jobs;
  };
}
