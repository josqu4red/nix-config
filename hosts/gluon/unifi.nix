{ ... }: let
  bindaddress = "127.0.0.1:8443";
  domain = "unifi.amiez.xyz";
in {
  nxmods.impermanence.directories = [ "/var/lib/unifi" ];

  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    locations."/".proxyPass = "https://${bindaddress}";
  };

  services.unifi = {
    enable = true;
    openFirewall = true;
    maximumJavaHeapSize = 1024;
  };
}
