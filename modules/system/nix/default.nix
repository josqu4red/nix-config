{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.cachix ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
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
  };
}
