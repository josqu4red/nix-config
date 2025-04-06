{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nxmods.tailscale;
in {
  options.nxmods.tailscale = {
    enable = mkEnableOption "Tailscale";
  };
  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    nxmods.impermanence.directories = [ "/var/lib/tailscale" ];
  };
}
