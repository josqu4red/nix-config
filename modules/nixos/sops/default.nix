{
  self,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    concatMapAttrs
    mapAttrs'
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    nameValuePair
    types
    ;
  cfg = config.nxmods.sops;
  hostDir = self.outPath + "/secrets/${config.networking.hostName}";
in
{
  imports = [ self.inputs.sops-nix.nixosModules.sops ];

  options.nxmods.sops = {
    enable = mkEnableOption "sops-nix";
    sopsFile = mkOption {
      type = types.path;
      default = hostDir + "/default.yaml";
      description = "Default sops file";
    };
    secrets = mkOption {
      default = { };
      description = ''
        Secret groups: each group `<name>` maps to the sops file
        `secrets/<host>/<name>.yaml`, its files to the `<name>/<file>` keys.
        File attributes are passed through to `sops.secrets`.
      '';
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              sopsFile = mkOption {
                type = types.path;
                default = hostDir + "/${name}.yaml";
              };
              owner = mkOption {
                type = with types; nullOr str;
                default = null;
                description = "Default owner of the group files";
              };
              files = mkOption {
                type = with types; attrsOf (attrsOf anything);
                default = { };
              };
            };
          }
        )
      );
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      sops = {
        defaultSopsFile = cfg.sopsFile;
        gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_rsa_key" ];
      };
    })
    {
      sops.secrets = concatMapAttrs (
        group: g:
        mapAttrs' (
          file: attrs:
          nameValuePair "${group}/${file}" ({ inherit (g) owner sopsFile; } // attrs)
        ) g.files
      ) cfg.secrets;
    }
  ];
}
