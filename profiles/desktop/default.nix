{ ... }: {
  imports = [
    ../workstation
  ];

  my.system.sshd.enable = true;
}
