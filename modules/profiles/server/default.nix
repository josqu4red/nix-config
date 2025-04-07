{ secrets, ... }: {
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
    disabledCollectors = [ "bonding" "fibrechannel" "infiniband" "ipvs" "mdadm" "nfsd" "tapestats" "zfs" ];
  };

  nxmods.acme = {
    enable = true;
    email = secrets.acme-email;
  };
}
