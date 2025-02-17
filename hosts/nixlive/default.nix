{ inputs, lib, ... }: {
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
    qemu.options = [
      # Better display option
      "-vga virtio"
      # Enable copy/paste
      # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
      "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
      "-device virtio-serial-pci"
      "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
    ];
  };
}
