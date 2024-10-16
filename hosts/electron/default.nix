{ inputs, lib, ... }: {
  imports = [
    inputs.self.nixosProfiles.server
    ./sd-image.nix
  ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    consoleLogLevel = lib.mkDefault 7;
    kernelParams = [ "console=tty0" "console=ttyAML0,115200n8" ];
  };
}
