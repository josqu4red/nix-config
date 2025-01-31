{ inputs, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    inputs.self.nixosProfiles.base
  ];

  virtualisation.vmVariant.virtualisation = {
    # diskSize = 10240;
    # memorySize = 4096;
    qemu.networkingOptions = lib.mkForce [
      # requires "allow br0" in /etc/qemu/bridge.conf
      "-net nic,model=virtio,macaddr=02:de:ad:00:06:66 -net bridge,br=br0"
    ];
  };
}
