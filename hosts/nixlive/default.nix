{ inputs, lib, pkgs, secrets, ... }: {
  imports = [
    inputs.nixos-generators.nixosModules.all-formats
    inputs.self.nixosProfiles.base
  ];

  virtualisation.vmVariant.virtualisation = {
    # diskSize = 10240;
    # memorySize = 4096;
    qemu.networkingOptions = lib.mkForce [
      # requires "allow br0" in /etc/qemu/bridge.conf
      "-net nic,model=virtio,macaddr=02:de:ad:00:06:66 -net bridge,br=br0"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = secrets.acme-email;
      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      # https://dash.cloudflare.com/ca9a409fba4035b96ba999bb185c815e/api-tokens
      # Zone:Read DNS:Edit
      environmentFile = pkgs.writeText "cloudflare-token" ''
        CF_DNS_API_TOKEN=
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."test.amiez.xyz" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:28981";
        proxyWebsockets = true;
      };
    };
  };
}
