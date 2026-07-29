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

    (pkgs.writeShellScriptBin "sops4" ''
      set -o errexit -o nounset -o pipefail

      binary_input=false
      force_key=false
      add_only=false
      while [ "$#" -gt 0 ]; do
        case "$1" in
          -a|--add-only)
            add_only=true
            shift
            ;;
          -b|--binary)
            binary_input=true
            shift
            ;;
          -f|--force)
            force_key=true
            shift
            ;;
          --)
            shift
            break
            ;;
          -*)
            echo "sops4: unknown option: $1" >&2
            echo "sops4 [-a|--add-only] [-b|--binary] [-f|--force] <host> <secret-path>" >&2
            exit 1
            ;;
          *)
            break
            ;;
        esac
      done

      if [ "$#" -ne 2 ]; then
        echo "sops4 [-a|--add-only] [-b|--binary] [-f|--force] <host> <secret-path>" >&2
        exit 1
      fi

      host=$1
      secret_path=$2
      gpg=${pkgs.gnupg}/bin/gpg
      sops=${pkgs.sops}/bin/sops

      fingerprint=$(
        "$gpg" --batch --with-colons --list-keys "$host" 2>/dev/null |
          ${pkgs.gawk}/bin/awk -F: '$1 == "fpr" { print $10; exit }'
      ) || true

      if [ "$force_key" = true ] || [ -z "$fingerprint" ]; then
        ${pkgs.coreutils}/bin/mkdir -p -- .sops
        key_file=".sops/host-$host.asc"
        key_tmp=$(${pkgs.coreutils}/bin/mktemp ".sops/.host-$host.XXXXXX.asc")
        trap '${pkgs.coreutils}/bin/rm -f -- "$key_tmp"' EXIT

        # https://github.com/Mic92/ssh-to-pgp/issues/61
        ${pkgs.openssh}/bin/ssh "$host" "sudo cat /etc/ssh/ssh_host_rsa_key" |
          ${ssh-to-pgp}/bin/ssh-to-pgp \
            -o "$key_tmp" \
            -email "host@$host" \
            -comment "" \
            -name "$host"

        fingerprint=$(
          "$gpg" --batch --with-colons --show-keys "$key_tmp" |
            ${pkgs.gawk}/bin/awk -F: '$1 == "fpr" { print $10; exit }'
        ) || true

        "$gpg" --batch --import "$key_tmp"
        ${pkgs.coreutils}/bin/mv -- "$key_tmp" "$key_file"
        trap - EXIT
      fi

      if [ -z "$fingerprint" ]; then
        echo "sops4: could not find a GPG key for $host" >&2
        exit 1
      fi

      sops_type_args=()
      if [ "$binary_input" = true ]; then
        sops_type_args+=(--input-type binary)
      fi

      if [ "$add_only" = false ]; then
        secret_dir=$(${pkgs.coreutils}/bin/dirname -- "$secret_path")
        ${pkgs.coreutils}/bin/mkdir -p -- "$secret_dir"

        if [ -t 0 ]; then
          "$sops" edit "''${sops_type_args[@]}" "$secret_path"
        else
          "$sops" encrypt \
            "''${sops_type_args[@]}" \
            --filename-override "$secret_path" \
            --output "$secret_path" \
            /dev/stdin
        fi
      fi

      "$sops" -i -r "''${sops_type_args[@]}" --add-pgp "$fingerprint" "$secret_path"
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
      backblaze-b2
      deadnix
      git-crypt
      kanidm_1_10
      nix-diff
      nix-index
      nix-prefetch-github
      nix-tree
      nurl
      nvd
      sops
      statix
    ]
    ++ scripts;
}
