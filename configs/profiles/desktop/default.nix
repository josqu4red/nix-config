{ ... }: {
  imports = [
    ../workstation
  ];

  services.openssh.settings.PasswordAuthentication = true;
}
