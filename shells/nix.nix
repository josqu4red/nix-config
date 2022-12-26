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
    ${pkgs.home-manager}/bin/home-manager build --flake .
    ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/per-user/jamiez/home-manager result
    if apply; then
      ${pkgs.home-manager}/bin/home-manager switch --flake .
    fi
  '';

  build-system = pkgs.writeScriptBin "build-system" ''
    ${apply}
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake .
    ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/system result
    if apply; then
      ${pkgs.sudo}/bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .
    fi
  '';
in
pkgs.mkShell {
  buildInputs = [ build-home build-system ];
}
