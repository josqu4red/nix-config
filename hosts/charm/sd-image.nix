{ config, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  sdImage = {
    compressImage = false;
    firmwarePartitionName = "boot";
    firmwarePartitionOffset = 32;
    firmwareSize = 200;
    populateFirmwareCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
    '';
  };
}
