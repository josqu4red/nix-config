{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nxmods.acme;
in {
  options.nxmods.acme = with types; {
    enable = mkEnableOption "ACME";
    email = mkOption {
      type = str;
      description = "Email address for Let's Encrypt account";
    };
    dnsProvider = mkOption {
      type = str;
      default = "cloudflare";
      description = "DNS provider for ACME challenges";
    };
    dnsResolver = mkOption {
      type = str;
      default = "1.1.1.1:53";
      description = "DNS resolver for ACME challenges";
    };
    dnsProviderSecret = mkOption {
      type = str;
      default = "cloudflare-token";
      description = "Environment file for DNS provider access";
    };
  };
  config = mkIf cfg.enable {
    assertions = [{ assertion = config.nxmods.sops.enable; message = "sops module must be enabled"; }];

    security.acme = {
      acceptTerms = true;
      defaults = {
        inherit (cfg) email dnsProvider dnsResolver;
        environmentFile = config.sops.secrets.${cfg.dnsProviderSecret}.path;
      };
    };

    nxmods = {
      impermanence.directories = [ "/var/lib/acme" ];
      backup.paths = [ "/var/lib/acme" ];
    };
  };
}
