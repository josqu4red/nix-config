{ config, hostname, lib, pkgs, ... }: let
  inherit (builtins) stringLength;
  inherit (lib.strings) replicate;
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (config.facts) hosts homeNet;
in {
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.bind = let
    padStr = len: str: "${str}${replicate (len - stringLength str) " "}";

    record = type: name: data: "${padStr 25 name} IN ${padStr 4 type} ${data}";
    aRecord = record "A";

    knownHosts = filterAttrs (n: v: v.ip != "") hosts;
    aRecords = mapAttrsToList (n: v: (aRecord n v.ip)) knownHosts;
    zone = homeNet.domain;
    dotDomain = "${zone}.";
  in {
    enable = true;
    cacheNetworks = [ "localhost" "localnets" ];
    extraOptions = ''
      allow-recursion { cachenetworks; };
    '';
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
      '';
    }];
  };
}
