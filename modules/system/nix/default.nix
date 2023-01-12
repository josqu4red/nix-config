{ pkgs, inputs, ... }:
let
  nixpkgsPath = "/etc/nixpkgs/channels/nixpkgs";
in {
  environment.systemPackages = [ pkgs.cachix ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
      cores = 0;
      auto-optimise-store = true;
      extra-substituters = [
        "https://josqu4red.cachix.org"
      ];
      extra-trusted-public-keys = [
        "josqu4red.cachix.org-1:S7wnALAmqClKxxHyIyUlraaltnPb5Q/lZPw2JyyjCrI="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Use flake's nixpkgs input in NIX_PATH, with systemd.tmpfiles below
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${nixpkgsPath}" ];
  };
  systemd.tmpfiles.rules = [ "L+ ${nixpkgsPath} - - - - ${inputs.nixpkgs}" ];
}
