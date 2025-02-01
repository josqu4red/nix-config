{ ... }: {
  nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=1G"
      "defaults"
      "mode=755"
    ];
  };
  disk.system = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "500M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        lvm = {
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "system";
          };
        };
      };
    };
  };
  lvm_vg.system = {
    type = "lvm_vg";
    lvs = {
      nix = {
        size = "100G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/nix";
          mountOptions = [ "noatime" ];
        };
      };
      persist = {
        size = "100G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/persist";
        };
      };
      tmp = {
        size = "100G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/tmp";
        };
      };
    };
  };
}
