{
  base = import ./base.nix;
  chrysalis = import ./chrysalis.nix;
  cli-tools = import ./cli-tools.nix;
  docker = import ./docker.nix;
  ledger = import ./ledger.nix;
  nix = import ./nix.nix;
  qFlipper = import ./qFlipper.nix;
  sshd = import ./sshd.nix;
  workstation = import ./workstation.nix;
  yubikey = import ./yubikey.nix;
}
