{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.autocutsel;
in {
  options.my.home.autocutsel = {
    enable = mkEnableOption "autocutsel";
  };
  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs) autocutsel;
    };

    systemd.user.services.autocutsel = {
      Unit = {
        Description = "autocutsel, sync X clipboard and cutbuffer";
      };

      Service = {
        Type = "forking";
        Restart = "always";
        RestartSec = 10;
        ExecStartPre = "${pkgs.autocutsel}/bin/autocutsel -fork";
        ExecStart = "${pkgs.autocutsel}/bin/autocutsel -fork -selection PRIMARY";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
