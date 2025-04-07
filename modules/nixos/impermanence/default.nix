{ self, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nxmods.impermanence;
in {
  imports = [ self.inputs.impermanence.nixosModules.impermanence ];

  options.nxmods.impermanence = with types; {
    enable = mkEnableOption "Impermanence";
    root = mkOption {
      type = path;
      default = "/persist";
      description = "Directory/mountpoint for persistent storage";
    };
    directories = mkOption {
      type = listOf path;
      default = [];
      example = [ "/var/log" ];
      description = "Directories to persist";
    };
    files = mkOption {
      type = listOf path;
      default = [];
      example = [ "/etc/machine-id" ];
      description = "Files to persist";
    };
  };
  config = let
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
    ] ++ cfg.directories;
    files = [
      "/etc/machine-id" # For journalctl
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ] ++ cfg.files;
  in mkIf cfg.enable {
    fileSystems.${cfg.root}.neededForBoot = true;
    environment.persistence.${cfg.root} = {
      hideMounts = true;
      inherit directories files;
    };
  };
}
