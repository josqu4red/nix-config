{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.proxy;
in
{
  options.nxmods.proxy = {
    enable = mkEnableOption "nginx reverse proxy";
  };
  config = mkIf cfg.enable {
    # TLS termination is the point, so the certs come with it
    nxmods.acme.enable = true;

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
