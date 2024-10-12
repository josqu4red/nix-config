{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.yubikey;
in {
  options.nxmods.yubikey.enable = mkEnableOption "Yubikey tools";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yubikey-manager yubikey-personalization yubikey-personalization-gui yubico-piv-tool yubioath-flutter yk-scripts ];
    services.udev.packages = [ pkgs.yubikey-personalization ];
  };
}
