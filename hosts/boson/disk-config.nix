{ ... }: {
  nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=4G"
      "defaults"
      "mode=755"
    ];
  };
  disk.system = {
    type = "disk";
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_1TB_S5RRNF0R643761Y";
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
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "system";
            settings = {
              allowDiscards = true;
              # dd if=/dev/random bs=4096 count=1 of=
              keyFile = "/dev/disk/by-id/usb-Generic_Flash_Disk_5E92B7D0-0:0";
              keyFileSize = 4096;
            };
            content = {
              type = "lvm_pv";
              vg = "system";
            };
          };
        };
      };
    };
  };
  lvm_vg.system = {
    type = "lvm_vg";
    lvs = {
      swap = {
        size = "16G";
        content = {
          type = "swap";
        };
      };
      nix = {
        size = "100G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/nix";
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
      home = {
        size = "100G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/home";
        };
      };
    };
  };
}
