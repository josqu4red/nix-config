{ config, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  sdImage = {
    compressImage = false;
    firmwarePartitionName = "boot";
    firmwarePartitionOffset = 32;
    firmwareSize = 200;
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
