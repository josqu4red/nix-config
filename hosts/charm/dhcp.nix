{ config, hostFacts, lib, ... }: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (config.facts) hosts homeNet;
  data-dir = "/var/lib/kea";
in {
  nxmods = {
    impermanence.directories = [ data-dir ];
    backup.paths = [ data-dir ];
  };

  networking.firewall.allowedUDPPorts = [ 67 ];

  # systemd dynamic users do not support impermanence
  systemd.services.kea-dhcp4-server.serviceConfig.DynamicUser = lib.mkForce false;
  users.groups.kea = {};
  users.users.kea = {
    isSystemUser = true;
    group = "kea";
  };

  services.kea.dhcp4 = let
    staticHosts = filterAttrs (n: v: (lib.and (v.ip != "") (v.mac != ""))) hosts;
    reservations = mapAttrsToList (n: v: { hostname = n; ip-address = v.ip; hw-address = v.mac; }) staticHosts;
    nameDataPair = mapAttrsToList (n: v: { name = n; data = v;});
    subnet = prefix: with prefix; "${address}/${builtins.toString length}";
  in {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ hostFacts.netIf ];
      };
      lease-database = {
        name = "${data-dir}/dhcp4.leases";
        persist = true;
        type = "memfile";
        lfc-interval = 86400;
      };
      option-data = nameDataPair {
        domain-name = homeNet.domain;
        domain-name-servers = hostFacts.ip;
        routers = homeNet.defaultGw;
      };
      host-reservation-identifiers = [ "hw-address" ];
      subnet4 = [{
        id = 1;
        subnet = subnet homeNet.prefix;
        pools = [ { pool = subnet homeNet.dhcp; } ];
        ddns-qualifying-suffix = homeNet.domain;
        reservations-out-of-pool = true;
        inherit reservations;
      }];
    };
  };
}
