{ config, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.my.system.nix;

  nixpkgsPath = "/etc/nixpkgs/channels/nixpkgs";
in {
  options.my.system.nix = {
    flakesNixpkgsInNixPath = mkEnableOption "flakesNixpkgsInNixPath";
    cachix.enable = mkEnableOption "cachix";
  };
  config = mkMerge [
    {
      nix = {
        settings = {
          allowed-users = [ "@wheel" ];
          experimental-features = [ "nix-command" "flakes" ];
          cores = 0;
          auto-optimise-store = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };
    }
    (mkIf cfg.flakesNixpkgsInNixPath {
      # Use flake's nixpkgs input in NIX_PATH, with systemd.tmpfiles below
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
      nix.nixPath = [ "nixpkgs=${nixpkgsPath}" ];
      systemd.tmpfiles.rules = [ "L+ ${nixpkgsPath} - - - - ${inputs.nixpkgs}" ];
    })
    (mkIf cfg.cachix.enable {
      environment.systemPackages = [ pkgs.cachix ];
      nix.settings = {
        extra-substituters = [ "https://josqu4red.cachix.org" ];
        extra-trusted-public-keys = [ "josqu4red.cachix.org-1:S7wnALAmqClKxxHyIyUlraaltnPb5Q/lZPw2JyyjCrI=" ];
      };
    })
  ];
}
