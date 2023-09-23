{ hostname, ... }: {
  system.stateVersion = "22.05";
  boot.swraid.enable = false; # true for stateVersion < 23.11

  networking.hostName = hostname;

  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.utf8";
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  my.system.cli-tools.enable = true;
  my.system.sshd.enable = true;
}
