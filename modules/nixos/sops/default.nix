{ self, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nxmods.sops;
in {
  imports = [ self.inputs.sops-nix.nixosModules.sops ];

  options.nxmods.sops = {
    enable = mkEnableOption "sops-nix";
    sopsFile = mkOption {
      type = types.path;
      default = self.outPath + "/secrets/${config.networking.hostName}/default.yaml";
      description = "Default sops file";
    };
  };
  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.sopsFile;
      gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_rsa_key" ];
    };
  };
}
