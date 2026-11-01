{ self, pkgs, ... }:
let
  bindaddress = "127.0.0.1:9443";
  domain = "id.amiez.xyz";
  dataDir = "/var/lib/kanidm";
  package = pkgs.kanidm_1_11;
  kanadmin = pkgs.writeShellScriptBin "kanadmin" ''
    exec sudo -u kanidm ${package}/bin/kanidmd "$@"
  '';
in
{
  nxmods.impermanence.directories = [ dataDir ];

  security.acme.certs.${domain} = {
    postRun = ''
      install -m0400 -okanidm -gkanidm {fullchain,key}.pem ${dataDir}
    '';
    reloadServices = [ "kanidm.service" ];
  };

  nxmods.dns.aliases = [ "id" ];
  services.nginx.virtualHosts.${domain} = self.lib.proxyVhost {
    upstream = "https://${bindaddress}";
  };

  services.kanidm = {
    inherit package;
    provision.enable = true;
    server = {
      enable = true;
      settings = {
        inherit bindaddress domain;
        origin = "https://${domain}";
        tls_chain = "${dataDir}/fullchain.pem";
        tls_key = "${dataDir}/key.pem";
      };
    };
  };

  environment.systemPackages = [ kanadmin ];
}
