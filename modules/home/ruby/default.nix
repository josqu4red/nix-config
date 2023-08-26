{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.ruby;
in {
  options.my.home.ruby = {
    enable = mkEnableOption "ruby";
  };
  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [ "ruby-2.7.8" "openssl-1.1.1u" "openssl-1.1.1v" ];
    home.packages = [ pkgs.ruby_2_7 ];
    home.file = {
      ".gemrc".source = ./gemrc;
      ".irbrc".source = ./irbrc;
    };
  };
}
