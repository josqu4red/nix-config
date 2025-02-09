let
  luksVol = name: {
    size = "100%";
    content = {
      inherit name;
      type = "luks";
      settings = {
        allowDiscards = true;
        # dd if=/dev/random bs=4096 count=1 of=
        keyFile = "/dev/disk/by-id/usb-SanDisk__Cruzer_Fit_4C530000280811109444-0:0";
        keyFileSize = 4096;
      };
      content = {
        type = "lvm_pv";
        vg = name;
      };
    };
  };
in {
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
    device = "/dev/disk/by-id/nvme-CT500P3SSD8_242649D49B41";
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
        luks = luksVol "system";
      };
    };
  };
  lvm_vg.system = {
    type = "lvm_vg";
    lvs = {
      home = {
        size = "10G";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/home";
        };
      };
      nix = {
        size = "50G";
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
  disk.data = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-CT4000P3PSSD8_2452E99D15EE";
    content = {
      type = "gpt";
      partitions = {
        luks = luksVol "data";
      };
    };
  };
  lvm_vg.data = {
    type = "lvm_vg";
    lvs = {
      cloud = {
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/var/lib/cloud";
        };
      };
    };
  };
}
