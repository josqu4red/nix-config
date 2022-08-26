{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.yubikey;
in {
  options.my.system.yubikey.enable = mkEnableOption "yubikey";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yubico-piv-tool yubikey-personalization yubioath-desktop yubikey-personalization-gui ];
    services.udev.packages = [ pkgs.yubikey-personalization ];
  };
}
