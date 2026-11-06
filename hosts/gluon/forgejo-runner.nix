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
  # rootless podman: the upstream module only supports the rootful socket
  runnerUser = "forgejo-runner";
  runnerUid = 2000; # fixed so the socket path is known at eval time
  runtimeDir = "/run/user/${toString runnerUid}";
  podmanSock = "${runtimeDir}/podman/podman.sock";
  podman = config.virtualisation.podman.package;
in
{
  nxmods.impermanence.directories = [ "/var/lib/${runnerUser}" ];

  users.groups.${runnerUser} = { };
  users.users.${runnerUser} = {
    isSystemUser = true;
    group = runnerUser;
    uid = runnerUid;
    home = "/var/lib/${runnerUser}";
    createHome = true;
    linger = true; # /run/user/<uid> and user dbus without a login
    autoSubUidGidRange = true;
  };

  # pasta copies the host IP into the container netns by default, so jobs
  # reaching git.amiez.xyz (= this host) never leave the namespace.
  virtualisation.containers.containersConf.settings.network.pasta_options = [
    "-a"
    "10.0.2.0"
    "-n"
    "24"
    "-g"
    "10.0.2.2"
  ];

  systemd.services.forgejo-runner-podman = {
    description = "Rootless podman API socket for the Forgejo runner";
    wantedBy = [ "multi-user.target" ];
    after = [ "user@${toString runnerUid}.service" ];
    requires = [ "user@${toString runnerUid}.service" ];
    path = [ "/run/wrappers" ]; # newuidmap/newgidmap
    environment = {
      XDG_RUNTIME_DIR = runtimeDir;
      DBUS_SESSION_BUS_ADDRESS = "unix:path=${runtimeDir}/bus";
    };
    serviceConfig = {
      User = runnerUser;
      Group = runnerUser;
      ExecStart = "${lib.getExe podman} system service --time=0 unix://${podmanSock}";
      Restart = "on-failure";
    };
  };

  sops.secrets."forgejo/runner_secret" = {
    owner = config.services.forgejo.user;
    sopsFile = self.outPath + "/secrets/gluon/forgejo.yaml";
  };

  systemd.services.forgejo-runner-register = {
    description = "Register the Forgejo Actions runner via shared secret";
    after = [ "forgejo.service" ];
    requires = [ "forgejo.service" ];
    # restarted along with forgejo (e.g. after the backup stops it)
    wantedBy = [
      "multi-user.target"
      "forgejo.service"
    ];
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
      # mkForce also dismisses the module's "docker label without runtime" assertion
      runtimes.podman = lib.mkForce false;
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

  systemd.services.forgejo-runner-nix = {
    after = [
      "forgejo-runner-register.service"
      "forgejo-runner-podman.service"
    ];
    requires = [
      "forgejo-runner-register.service"
      "forgejo-runner-podman.service"
    ];
    wantedBy = [ "forgejo.service" ];
    environment.DOCKER_HOST = "unix://${podmanSock}";
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = runnerUser;
      Group = runnerUser;
    };
  };
}
