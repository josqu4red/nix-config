{ config, hostFacts, lib, ... }: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (config.facts) hosts networks dns;
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
        interfaces = [ hostFacts.netIf "vlan10" ];
      };
      lease-database = {
        name = "${data-dir}/dhcp4.leases";
        persist = true;
        type = "memfile";
        lfc-interval = 86400;
      };
      host-reservation-identifiers = [ "hw-address" ];
      subnet4 = with networks; [
        {
          id = 1;
          subnet = subnet home.prefix;
          pools = [ { pool = subnet home.dhcp; } ];
          option-data = nameDataPair {
            domain-name = dns.internalDomain;
            domain-name-servers = hostFacts.ip;
            routers = home.gateway;
          };
          ddns-qualifying-suffix = dns.internalDomain;
          reservations-out-of-pool = true;
          inherit reservations;
        }
        {
          id = 2;
          subnet = subnet iot.prefix;
          pools = [ { pool = subnet iot.dhcp; } ];
          option-data = nameDataPair {
            domain-name = dns.internalDomain;
            domain-name-servers = "192.168.10.2";
          };
        }
      ];
    };
  };
}
