{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.pass;
in {
  options.my.home.pass = {
    enable = mkEnableOption "pass";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wl-clipboard ]; # TODO: wayland only
    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };
  };
}
