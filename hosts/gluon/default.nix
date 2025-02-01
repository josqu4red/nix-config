{ inputs, pkgs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.self.nixosProfiles.server
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

  nxmods.impermanence = {
    enable = true;
    directories = [ "/opt/cni" ] ++ map (d: "/var/lib/${d}") [ "cni" "kubelet" "rancher" ];
  };

  networking.firewall.enable = false;
  environment.systemPackages = with pkgs; [ k9s kubectl ];
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--disable servicelb,traefik,local-storage,metrics-server"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--disable-kube-proxy"
      "--disable-helm-controller"
      "--cluster-cidr=10.42.0.0/16"
      "--service-cidr=10.43.0.0/16"
    ];
  };
}
