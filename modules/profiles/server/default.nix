{ secrets, pkgs, ... }:
let
  textfile-dir = "/var/lib/node-exporter-textfiles";
in
{
  imports = [
    ../base
  ];

  time.timeZone = "UTC";

  services.timesyncd.enable = true;

  programs.bash.shellAliases = {
    l = "ls -lh";
    la = "ls -Alh";
    rr = "rm -rf";
    md = "mkdir -p";
    rd = "rmdir";
    j = "sudo journalctl";
    s = "sudo systemctl";
    sudo = "sudo ";
  };

  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    disabledCollectors = [
      "bonding"
      "fibrechannel"
      "infiniband"
      "ipvs"
      "mdadm"
      "nfsd"
      "tapestats"
      "zfs"
    ];
    extraFlags = [
      "--collector.textfile.directory=${textfile-dir}"
    ];
  };

  system.activationScripts.node-exporter-system-version =
    let
      nixos_info = pkgs.writeShellScriptBin "nixos-info" ''
        set -euo pipefail

        VERSION="$(cat /run/current-system/nixos-version)"
        CURRENT_SYSTEM_DRV="$(readlink /run/current-system)"
        CURRENT_SYSTEM_PROFILE="$(find /nix/var/nix/profiles -ilname "''${CURRENT_SYSTEM_DRV}")"
        DEPLOY_TIMESTAMP="$(stat -c '%y' "''${CURRENT_SYSTEM_PROFILE}" | cut -c '-16')"

        echo "nixos_info{version=\"''${VERSION}\",date=\"''${DEPLOY_TIMESTAMP}\"} 1"
      '';
    in
    ''
      mkdir -pm 1777 ${textfile-dir}
      ${nixos_info}/bin/nixos-info | ${pkgs.moreutils}/bin/sponge ${textfile-dir}/nixos_info.prom
    '';

  nxmods.acme.email = secrets.acme-email;
}
