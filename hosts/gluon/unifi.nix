{
  self,
  lib,
  pkgs,
  ...
}:
let
  bindaddress = "127.0.0.1:8443";
  domain = "unifi.amiez.xyz";
in
{
  nxmods.impermanence.directories = [ "/var/lib/unifi" ];

  nxmods.dns.aliases = [ "unifi" ];
  services.nginx.virtualHosts.${domain} = self.lib.proxyVhost {
    upstream = "https://${bindaddress}";
  };

  services.unifi = {
    enable = true;
    openFirewall = true;
    maximumJavaHeapSize = 1024;
  };

  systemd.services.unifi.serviceConfig.ExecStop = lib.mkAfter [
    "${lib.getExe' pkgs.util-linux "waitpid"} -t 30 -e $MAINPID"
  ];
  systemd.services.unifi.serviceConfig.KillSignal = lib.mkForce "SIGTERM";
}
