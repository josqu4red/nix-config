{ config, hostFacts, hostname, lib, pkgs, ... }: let
  inherit (builtins) stringLength;
  inherit (lib.strings) replicate;
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib) concatLists listToAttrs nameValuePair;
  inherit (config.facts) hosts dns;
in {
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  # TODO: auto create
  systemd.tmpfiles.rules = [ ''f /etc/named/amiez.xyz-extra - - - - "; papers IN CNAME  gluon.in.amiez.xyz."'' ];

  services.bind = let
    # DNS zone helpers
    padStr = len: str: "${str}${replicate (len - stringLength str) " "}";
    record = type: name: data: "${padStr 25 name} IN ${padStr 6 type} ${data}";
    aRecord = record "A";
    cnameRecord = record "CNAME";

    # Map of hostname->address from facts
    knownHosts = filterAttrs (n: v: v.ip != "") hosts;
    # Map of alias->hostname from facts
    aliases = listToAttrs (concatLists (mapAttrsToList (n: v: map (alias: (nameValuePair alias n)) v.aliases) hosts));

    zoneHeader = name: let
      dotName = "${name}.";
    in ''
      ; ${dotName} zone
      $TTL 300
      $ORIGIN ${dotName}
      ${record "SOA" "@" "${hostname}.${dotName} root.${dotName} (1 7200 1200 1209600 360)"}
      ${record "NS" "@" "${hostname}.${dotName}"}
    '';

    splitZone = name: cnameDomain: let
      cnameRecords = mapAttrsToList (n: v: (cnameRecord n "${v}.${cnameDomain}.")) aliases;
    in pkgs.writeText name ''
      ${zoneHeader name}
      ${aRecord hostname hostFacts.ip}
      ${builtins.concatStringsSep "\n" cnameRecords}
      $INCLUDE /etc/named/${name}-extra
    '';

    localZone = name: let
      aRecords = mapAttrsToList (n: v: (aRecord n v.ip)) knownHosts;
      cnameRecords = mapAttrsToList (n: v: (cnameRecord n v)) aliases;
    in pkgs.writeText name ''
      ${zoneHeader name}
      ${builtins.concatStringsSep "\n" aRecords}
      ${builtins.concatStringsSep "\n" cnameRecords}
    '';
  in {
    enable = true;
    configFile = let
      privZone = dns.internalDomain;
      pubZone = "amiez.xyz";
      tailnetZone = "banjo-chromatic.ts.net";
      tailnetNs = "100.100.100.100";
    in pkgs.writeText "named.conf" ''
      include "/etc/bind/rndc.key";
      controls {
        inet 127.0.0.1 allow {localhost;} keys {"rndc-key";};
      };

      acl badnetworks {  };
      acl homenet { localhost; 192.168.1.0/24; };
      acl tailnet { 100.64.0.0/10; };

      options {
        listen-on { any; };
        listen-on-v6 { any; };
        allow-query-cache { homenet; tailnet; };
        blackhole { badnetworks; };
        forward first;
        forwarders { };
        directory "/run/named";
        pid-file "/run/named/named.pid";
      };

      view homenet {
        match-clients { homenet; };
        zone "${pubZone}" {
          type primary;
          file "${splitZone pubZone privZone}";
        };
        zone "${privZone}" {
          type primary;
          file "${localZone privZone}";
        };
      };

      view tailnet {
        match-clients { tailnet; };
        zone "${pubZone}" {
          type primary;
          file "${splitZone pubZone tailnetZone}";
        };
        zone "${tailnetZone}" {
          type forward;
          forward only;
          forwarders { ${tailnetNs}; };
        };
      };
    '';
  };
}
