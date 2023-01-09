{ pkgs }:
let
  apply = ''
    # get user input
    apply() {
      echo -n "switch? (y/N) "
      read a
      if [ "x$a" = "xy" ]; then
        return 0
      else
        return 1
      fi
    }
  '';

  build-home = pkgs.writeScriptBin "build-home" ''
    ${apply}
    ${pkgs.home-manager}/bin/home-manager build --flake . || exit 1
    ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/per-user/jamiez/home-manager result
    if apply; then
      ${pkgs.home-manager}/bin/home-manager switch --flake .
    fi
  '';

  build-system = pkgs.writeScriptBin "build-system" ''
    ${apply}
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake . || exit 1
    ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/system result
    if apply; then
      # TODO: pkgs.sudo: /nix/store/yvf9z9p3ghlpixikxk02ad6l5lnl1krg-sudo-1.9.12p1/bin/sudo must be owned by uid 0 and have the setuid bit set
      sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .
    fi
  '';
in
pkgs.mkShell {
  buildInputs = [ build-home build-system ];
}
