{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.nxmods.networkd;

  toList = value: if value == "" then [] else [value];
  toRoute = map (v: {
    Destination = v;
    Scope = "link";
  });

  interfaceType = with types; submodule {
    options = {
      name = mkOption {
        description = "Interface name";
        type = str;
      };
      address = mkOption {
        description = "Interface CIDR address";
        type = str;
        default = "";
        apply = toList;
      };
      gateway = mkOption {
        description = "Interface gateway";
        type = str;
        default = "";
        apply = toList;
      };
      routes = mkOption {
        description = "Interface routes";
        type = listOf str;
        default = [];
        apply = toRoute;
      };
      id = mkOption {
        description = "Interface VLAN ID";
        type = int;
        default = null;
      };
    };
  };
in {
  options.nxmods.networkd = with types; {
    enable = mkEnableOption "systemd-networkd";
    mainInterface = mkOption {
      description = "Main interface config";
      type = interfaceType;
    };
    vlanInterfaces = mkOption {
      description = "VLAN interfaces config";
      default = [];
      type = listOf interfaceType;
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
      vlanName = v: "vlan${toString v.id}";
      dhcpConfig = enabled: if enabled then {
        DHCP = "yes";
        IPv6PrivacyExtensions = "kernel";
        UseDomains = true;
      } else {};

      mainConfig = with cfg.mainInterface; {
        networks."10-${name}" = {
            matchConfig.Name = [ name ];
            linkConfig.RequiredForOnline = "routable";
            inherit address gateway routes;
            vlan = map vlanName cfg.vlanInterfaces;
            networkConfig = dhcpConfig (address == []);
        };
      };

      vlanConfig = lib.attrsets.mergeAttrsList (map (vlan: let
        Name = vlanName vlan;
      in with vlan; {
        netdevs."20-${Name}" = {
          netdevConfig = {
            Kind = "vlan";
            inherit Name;
          };
          vlanConfig.Id = id;
        };
        networks."20-${Name}" = {
          matchConfig = { inherit Name; };
          inherit address gateway routes;
        }; }) cfg.vlanInterfaces);

      bridgeConfig = with cfg.mainInterface; {
        netdevs."10-${name}" = {
          netdevConfig = {
            Kind = "bridge";
            MACAddress = cfg.bridge.macaddress;
            Name = name;
          };
        };
        networks."10-bridged" = {
          matchConfig.Name = cfg.bridge.interfaces;
          networkConfig.Bridge = name;
        };
      };
    in mkMerge [
      ({ enable = true; })
      (mainConfig)
      (vlanConfig)
      (mkIf (cfg.bridge.enable) bridgeConfig)
    ];
  };
}
