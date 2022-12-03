{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.ledger;
in {
  options.my.system.ledger.enable = mkEnableOption "ledger";
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ledger-live-desktop ];
    hardware.ledger.enable = true;
  };
}
