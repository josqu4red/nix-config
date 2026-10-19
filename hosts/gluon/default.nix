{
  config,
  inputs,
  hostFacts,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.server
    ./dhcp.nix
    ./dns.nix
    ./grafana.nix
    ./ha
    ./kanidm.nix
    ./monitoring.nix
    ./mqtt.nix
    ./nextcloud.nix
    ./paperless.nix
    ./unifi.nix
  ];

  disko.devices = import ./disk-config.nix;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "sd_mod"
    ];
    initrd.kernelModules = [
      "dm-snapshot"
      "usb_storage"
    ];
    kernelModules = [ "kvm-amd" ];
    tmp.cleanOnBoot = true;
  };

  networking = with config.facts.dns; {
    domain = internalDomain;
    search = [ internalDomain ];
    nameservers = [ "127.0.0.1" ];
  };

  # address also need to be set in freebox' DNSv6 field
  systemd.network.networks."10-${hostFacts.netIf}" = {
    address = [ "fd0f:ee:b0::3/64" ];
    networkConfig = {
      IPv6SendRA = true;
      IPv6AcceptRA = true;
    };
    ipv6Prefixes = [ { Prefix = "fd0f:ee:b0::/64"; } ];
    ipv6SendRAConfig = {
      RouterLifetimeSec = 0;
      EmitDNS = true;
      DNS = [ "fd0f:ee:b0::3" ];
    };
  };

  nxmods = {
    impermanence.enable = true;
    networkd = {
      enable = true;
      mainInterface = with config.facts.networks.home; {
        name = hostFacts.netIf;
        address = "${hostFacts.ip}/${toString prefix.length}";
        inherit gateway;
      };
      vlanInterfaces = [
        {
          name = "vlan10";
          address = "192.168.10.3/24";
          id = 10;
          routes = [ "192.168.10.0/24" ];
        }
      ];
    };
    proxy.enable = true;
    sops.enable = true;
    tailscale.enable = true;
  };

  sops.secrets."cloudflare-token" = {
    sopsFile = inputs.self.outPath + "/secrets/shared/cloudflare-token-amiez.xyz";
    key = "";
  };

}
