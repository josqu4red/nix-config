{ inputs, lib, ... }: {
  imports = [
    inputs.nixos-generators.nixosModules.all-formats
    inputs.self.nixosProfiles.base
    ../gluon/paperless.nix
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
