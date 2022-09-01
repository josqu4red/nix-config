{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      cores = 0;
      auto-optimise-store = true;
    };
  };
}
