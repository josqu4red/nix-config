{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.ledger;
in {
  options.nxmods.ledger.enable = mkEnableOption "Ledger Live";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ledger-live-desktop ];
    hardware.ledger.enable = true;
  };
}
