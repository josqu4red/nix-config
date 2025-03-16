{ config, hostname, lib, pkgs, ... }: let
  inherit (builtins) stringLength;
  inherit (lib.strings) replicate;
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib) concatLists listToAttrs nameValuePair;
  inherit (config.facts) hosts homeNet;
in {
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.bind = let
    padStr = len: str: "${str}${replicate (len - stringLength str) " "}";

    record = type: name: data: "${padStr 25 name} IN ${padStr 6 type} ${data}";
    aRecord = record "A";
    cnameRecord = record "CNAME";

    knownHosts = filterAttrs (n: v: v.ip != "") hosts;
    aRecords = mapAttrsToList (n: v: (aRecord n v.ip)) knownHosts;

    aliases = listToAttrs (concatLists (mapAttrsToList (n: v: map (alias: (nameValuePair alias n)) v.aliases) hosts));
    cnameRecords = mapAttrsToList (n: v: (cnameRecord n v)) aliases;

    zone = homeNet.domain;
    dotDomain = "${zone}.";
  in {
    enable = true;
    cacheNetworks = [ "localhost" "localnets" ];
    extraOptions = ''
      allow-recursion { cachenetworks; };
    '';
    forwarders = [];
    zones = [{
      name = zone;
      master = true;
      extraConfig = "";
      file = pkgs.writeText zone ''
        ; ${dotDomain} zone
        $TTL 300
        $ORIGIN ${dotDomain}
        ${record "SOA" "@" "${hostname}.${dotDomain} root.${dotDomain} (1 7200 1200 1209600 360)"}
        ${record "NS" "@" "${hostname}.${dotDomain}"}
        ${builtins.concatStringsSep "\n" aRecords}
        ${builtins.concatStringsSep "\n" cnameRecords}
      '';
    }];
  };
}
