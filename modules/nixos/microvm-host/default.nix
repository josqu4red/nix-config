{ self, config, lib, ... }:
let
  inherit (self.lib) machineId;
  inherit (lib) genAttrs mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.nxmods.microvm-host;
in {
  imports = [ self.inputs.microvm.nixosModules.host ];

  options.nxmods.microvm-host = {
    enable = mkEnableOption "MicroVM host";
    vms = mkOption {
      type = with types; listOf str;
      default = [];
      example = [ "serverx" ];
      description = "MicroVMs to host";
    };
  };
  config = mkMerge [
    ({
      microvm.host.enable = cfg.enable;
    })
    (mkIf cfg.enable {
      nxmods.impermanence.directories = [ "/var/lib/microvms" ];

      microvm.vms = genAttrs cfg.vms (_: { flake = self; });

      systemd.tmpfiles.rules = map (name: let id = machineId name;
                                    in "L+ /var/log/journal/${id} - - - - /var/lib/microvms/${name}/journal/${id}")
                                    cfg.vms;
    })
  ];
}
