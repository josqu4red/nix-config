{ ... }: {
  imports = [
    ../workstation
  ];

  my.system.sshd.passwordAuth = true;
}
