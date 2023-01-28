{ ... }: {
  imports = [
    ../workstation
  ];

  my.system.sshd = {
    enable = true;
    passwordAuth = true;
  };
}
