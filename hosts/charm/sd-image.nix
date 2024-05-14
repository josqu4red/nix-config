{ config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  system.nixos.variant_id = "installer";

  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = with lib; concatLists
    (mapAttrsToList
      (name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else [])
      config.users.users);

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
