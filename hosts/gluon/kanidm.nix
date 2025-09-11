{ pkgs, ... }: let
  bindaddress = "127.0.0.1:8443";
  domain = "id.amiez.xyz";
  dataDir = "/var/lib/kanidm";
  package = pkgs.kanidm_1_7;
  kanadmin = pkgs.writeShellScriptBin "kanadmin" ''
    exec sudo -u kanidm ${package}/bin/kanidmd "$@"
  '';
in {
  security.acme.certs.${domain} = {
    postRun = ''
      install -m0400 -okanidm -gkanidm {fullchain,key}.pem ${dataDir}
    '';
    reloadServices = ["kanidm.service"];
  };

  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    locations."/".proxyPass = "https://${bindaddress}";
  };

  services.kanidm = {
    inherit package;
    enableServer = true;
    serverSettings = {
      inherit bindaddress domain;
      origin = "https://${domain}";
      tls_chain = "${dataDir}/fullchain.pem";
      tls_key = "${dataDir}/key.pem";
    };
  };

  environment.systemPackages = [ kanadmin ];
}
