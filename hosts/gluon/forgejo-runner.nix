{
  self,
  config,
  lib,
  ...
}:
let
  hostName = "git.amiez.xyz";
  runnerSecret = config.sops.secrets."forgejo/runner_secret".path;
  # sops -d --extract '["forgejo"]["runner_secret"]' secrets/gluon/forgejo.yaml | head -c16 | xxd -p
  runnerUuid = "64326666-3565-6539-6637-613332646566";
in
{
  sops.secrets."forgejo/runner_secret" = {
    owner = config.services.forgejo.user;
    sopsFile = self.outPath + "/secrets/gluon/forgejo.yaml";
  };

  systemd.services.forgejo-runner-register = {
    description = "Register the Forgejo Actions runner via shared secret";
    after = [ "forgejo.service" ];
    requires = [ "forgejo.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      FORGEJO_WORK_DIR = config.services.forgejo.stateDir;
      FORGEJO_CUSTOM = config.services.forgejo.customDir;
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = config.services.forgejo.user;
      Group = config.services.forgejo.group;
    };
    script = ''
      ${lib.getExe config.services.forgejo.package} forgejo-cli actions register \
        --secret-file ${runnerSecret} --name nix
    '';
  };

  services.forgejo-runner = {
    instances.nix = {
      enable = true;
      runtimes.podman = true;
      settings.runner = {
        capacity = 2;
        labels = [
          "nix:docker://git.amiez.xyz/home/nix-action-runner:latest"
        ];
      };
      settings.container = {
        force_pull = true;
        docker_host = "-";
        privileged = false;
        valid_volumes = [ ];
      };
      secrets.server.connections.default.token_url = runnerSecret;
      settings.server.connections.default = {
        url = "https://${hostName}";
        uuid = runnerUuid;
        token = null;
      };
    };
  };

  systemd.services."forgejo-runner-nix" = {
    after = [ "forgejo-runner-register.service" ];
    requires = [ "forgejo-runner-register.service" ];
  };
}
