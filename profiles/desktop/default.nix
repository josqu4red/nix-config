{ ... }: {
  imports = [
    ../workstation
  ];

  custom.sshd.passwordAuth = true;
}
