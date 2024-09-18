{ self, config, lib, hostname, ... }:
let
  inherit (self.lib) macAddress machineId;
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.nxmods.microvm-guest;
in {
  imports = [ self.inputs.microvm.nixosModules.microvm ];

  options.nxmods.microvm-guest = {
    enable = mkEnableOption "MicroVM guest";
  };

  config = mkMerge [
    ({
      microvm.guest.enable = cfg.enable;
    })
    (mkIf cfg.enable {
      environment.etc."machine-id" = {
        mode = "0644";
        text = machineId hostname;
      };
      microvm = {
        hypervisor = "qemu";
        interfaces = [{
          id = hostname;
          type = "macvtap";
          mac = macAddress hostname;
          macvtap.link = "end0"; # TODO
          macvtap.mode = "bridge";
        }];
        shares = [{
          proto = "virtiofs";
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }{
          proto = "virtiofs";
          tag = "journal";
          source = "/var/lib/microvms/${hostname}/journal";
          mountPoint = "/var/log/journal";
          socket = "journal.sock";
        }];
      };
    })
  ];
}
