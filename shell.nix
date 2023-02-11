{ pkgs, sops-import-keys-hook }:
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

  scripts = [
    (pkgs.writeShellScriptBin "build-home" ''
      ${apply}
      ${pkgs.home-manager}/bin/home-manager build --flake . || exit 1
      ${pkgs.nvd}/bin/nvd diff ~/.local/state/nix/profiles/home-manager result
      if apply; then
        ${pkgs.home-manager}/bin/home-manager switch --flake .
      fi
    '')

    (pkgs.writeShellScriptBin "build-remote" ''
      [ $# -lt 2 ] && echo "build-remote <boot|switch> <confname> [hostname]" && exit 1
      action=$1
      host=$2
      [ $# -ne 3 ] && fqdn=$2 || fqdn=$3
      ${apply}
      ${pkgs.nix}/bin/nix build .#nixosConfigurations.$host.config.system.build.toplevel || exit 1
      result=$(readlink -f result)
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake .#$host --target-host $fqdn --use-remote-sudo || exit 1
      ${pkgs.openssh}/bin/ssh -t $fqdn -- nix-shell -p nvd --run \"nvd diff /nix/var/nix/profiles/system $result\"
      if apply; then
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild $action --flake .#$host --target-host $fqdn --use-remote-sudo || exit 1
      fi
    '')

    (pkgs.writeShellScriptBin "build-system" ''
      [ $# -lt 1 ] && action=boot || action=$1
      ${apply}
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake . || exit 1
      ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/system result
      if apply; then
        # TODO: pkgs.sudo: /nix/store/yvf9z9p3ghlpixikxk02ad6l5lnl1krg-sudo-1.9.12p1/bin/sudo must be owned by uid 0 and have the setuid bit set
        sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild $action --flake .
      fi
    '')

    (pkgs.writeShellScriptBin "cleanix" ''
      [ $# -ne 1 ] && echo "cleanix <number of generations to keep>" && exit 1
      keep=$1

      # home
      nix-env --delete-generations +$keep
      home-manager remove-generations $(home-manager generations | awk "(NR>$keep) {print \$5}" | tr '\n' ' ')

      # system
      sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +$keep
      sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild boot --flake .
    '')

    (pkgs.writeShellScriptBin "get-sops-key" ''
      [ $# -lt 1 ] && echo "get-sops-key <host> [name]" && exit 1
      host=$1
      [ $# -ne 2 ] && name=$1 || name=$2
      # https://github.com/Mic92/ssh-to-pgp/issues/61
      ssh $host "sudo cat /etc/ssh/ssh_host_rsa_key" | ${pkgs.ssh-to-pgp}/bin/ssh-to-pgp -o .sops/host-$name.asc -email host@$name -comment "" -name $name
    '')
  ];

in
pkgs.mkShell {
  sopsPGPKeyDirs = [ ./.sops ];
  nativeBuildInputs = [ sops-import-keys-hook ];
  buildInputs = with pkgs; [ deadnix git-crypt nix-diff nix-index nix-prefetch-github nix-tree nurl nvd sops statix ] ++ scripts;
}
