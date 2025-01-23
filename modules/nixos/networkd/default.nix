{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.nxmods.networkd;
in {
  options.nxmods.networkd = with types; {
    enable = mkEnableOption "systemd-networkd";
    interface = mkOption {
      description = "Interface name";
      default = "eth0";
      type = str;
    };
    address = mkOption {
      description = "Interface ip.ad.dr.ess/cidr";
      default = "";
      type = str;
    };
    gateway = mkOption {
      description = "Interface default route";
      default = "";
      type = str;
    };
    bridge = mkOption {
      description = "Bridge interface config";
      default = {};
      type = submodule {
        options = {
          enable = mkEnableOption "systemd-networkd bridge";
          interfaces = mkOption {
            description = "Interfaces to bridge";
            type = listOf str;
          };
          macaddress = mkOption {
            description = "Bridge MAC address";
            type = str;
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    networking.useNetworkd = true;
    systemd.network = let
      static-config = {
        address = [ cfg.address ];
        routes = [{ Gateway = cfg.gateway; }];
      };
      dhcp-config = {
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          UseDomains = true;
        };
      };
      if-config = if cfg.address == "" then dhcp-config else static-config;
      phy-config = {
        networks."10-phy" = {
          matchConfig.Name = [ cfg.interface ];
          linkConfig.RequiredForOnline = "routable";
        } // if-config;
      };
      bridge-config = {
        networks."10-bridged" = {
          matchConfig.Name = cfg.bridge.interfaces ;
          networkConfig.Bridge = cfg.interface;
        };
        netdevs."${cfg.interface}" = {
          netdevConfig = {
            Kind = "bridge";
            MACAddress = cfg.bridge.macaddress;
            Name = cfg.interface;
          };
        };
      };
    in mkMerge [
      ({ enable = true; })
      (phy-config)
      (mkIf (cfg.bridge.enable) bridge-config)
    ];
  };
}
