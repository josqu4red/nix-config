{ config, modulesPath, pkgsCross, ... }: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  sdImage = {
    compressImage = false;
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    postBuildCommands = ''
      dd if=${pkgsCross.ubootLibreTechCC}/u-boot.gxl.sd.bin of=$img conv=fsync,notrunc bs=512 seek=1 skip=1
      dd if=${pkgsCross.ubootLibreTechCC}/u-boot.gxl.sd.bin of=$img conv=fsync,notrunc bs=1 count=444
    '';
  };
}
