_: {
  disk.system = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = "boot";
          start = "1MiB";
          end = "1GiB";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        }
        {
          name = "swap";
          start = "1GiB";
          end = "9GiB";
          content = {
            type = "swap";
          };
        }
        {
          name = "root";
          start = "9GiB";
          end = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        }
      ];
    };
  };
}
