{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.yubikey;
in {
  options.my.system.yubikey.enable = mkEnableOption "yubikey";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yubikey-manager yubikey-personalization yubikey-personalization-gui yubico-piv-tool yubioath-desktop ];
    services.udev.packages = [ pkgs.yubikey-personalization ];
  };
}
