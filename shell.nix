{
  pkgs,
  sops-import-keys-hook,
  ssh-to-pgp,
}:
let
  apply = ''
    # get user input
    apply() {
      echo -n "$1? (y/N) "
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
      ${pkgs.nix}/bin/nix build --profile .gcroots/nixos-build-$host .#nixosConfigurations.$host.config.system.build.toplevel || exit 1
      result=$(readlink -f result)
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake .#$host --target-host $fqdn --sudo || exit 1
      ${pkgs.openssh}/bin/ssh -t $fqdn -- nvd diff /nix/var/nix/profiles/system $result
      if apply $action; then
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild $action --flake .#$host --target-host $fqdn --sudo || exit 1
      fi
    '')

    (pkgs.writeShellScriptBin "build-system" ''
      [ $# -lt 1 ] && action=boot || action=$1
      ${apply}
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake . || exit 1
      ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/system result
      if apply $action; then
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

    # https://github.com/Mic92/ssh-to-pgp/issues/61
    # then add the fingerprint to .sops.yaml and run `sops updatekeys`
    (pkgs.writeShellScriptBin "get-host-key" ''
      set -o errexit -o nounset -o pipefail
      [ $# -ne 1 ] && echo "get-host-key <host>" >&2 && exit 1
      host=$1
      ${pkgs.coreutils}/bin/mkdir -p .sops
      ${pkgs.openssh}/bin/ssh "$host" "sudo cat /etc/ssh/ssh_host_rsa_key" |
        ${ssh-to-pgp}/bin/ssh-to-pgp -o ".sops/host-$host.asc" -email "host@$host" -comment "" -name "$host"
    '')

    (pkgs.writeShellScriptBin "copy-remote-system" ''
      [ $# -lt 1 ] && echo "get-sops-key <host>" && exit 1
      host=$1
      nix copy --no-check-sigs --from ssh://$host $(ssh $host "readlink -f /nix/var/nix/profiles/system")
    '')
  ];

in
pkgs.mkShell {
  sopsPGPKeyDirs = [ ./.sops ];
  nativeBuildInputs = [
    sops-import-keys-hook
    ssh-to-pgp
  ];
  buildInputs =
    with pkgs;
    [
      attic-client
      backblaze-b2
      deadnix
      git-crypt
      kanidm_1_11
      nix-diff
      nix-index
      nix-prefetch-github
      nix-tree
      nixfmt
      nurl
      nvd
      sops
      statix
    ]
    ++ scripts;
}
