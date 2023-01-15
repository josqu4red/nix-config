{ ... }: {
  imports = [
    ../base
  ];

  time.timeZone = "UTC";

  my.system.sshd.enable = true;
}
