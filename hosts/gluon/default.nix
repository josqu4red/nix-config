{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.server
    ./nextcloud.nix
    ./paperless.nix
  ];

  disko.devices = import ./disk-config.nix;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" "usb_storage" ];
    kernelModules = [ "kvm-amd" ];
    tmp.cleanOnBoot = true;
  };

  nxmods = {
    impermanence.enable = true;
    sops.enable = true;
    tailscale.enable = true;
  };

  sops.secrets."cloudflare-token" = {
    sopsFile = inputs.self.outPath + "/secrets/shared/cloudflare-token-amiez.xyz";
    key = "";
  };

  networking.firewall.allowedTCPPorts = [80 443];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
