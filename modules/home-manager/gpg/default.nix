{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    defaultCacheTtl = 21600;
    maxCacheTtl = 43200;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
}
