{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nxmods.networkd;
in {
  options.nxmods.networkd = with types; {
    enable = mkEnableOption "systemd-networkd";
    bridge = mkOption {
      description = "Bridge interface config";
      default = {};
      type = submodule {
        options = {
          name = mkOption {
            description = "Bridge name";
            default = "br0";
            type = str;
          };
          macaddress = mkOption {
            description = "Bridge MAC address";
            default = "none";
            type = str;
          };
          interfaces = mkOption {
            description = "Interfaces to bridge";
            default = [ "eth0" ];
            type = listOf str;
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks = {
        "10-bridged" = {
          matchConfig.Name = cfg.bridge.interfaces;
          networkConfig.Bridge = cfg.bridge.name;
        };
        "10-bridge" = {
          matchConfig.Name = [ cfg.bridge.name ];
          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
            UseDomains = true;
          };
          linkConfig.RequiredForOnline = "routable";
        };
      };
      netdevs."${cfg.bridge.name}" = {
        netdevConfig = {
          Kind = "bridge";
          MACAddress = cfg.bridge.macaddress;
          Name = cfg.bridge.name;
        };
      };
    };
  };
}
