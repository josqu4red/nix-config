{ lib, pkgs, username, stateVersion, ... }: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  # force to avoid having to set users.users.user.home
  homeDirectory = lib.mkForce (if isDarwin then "/Users/${username}" else "/home/${username}");
in {
  home = { inherit homeDirectory username stateVersion; };
  programs.home-manager.enable = true;
}
