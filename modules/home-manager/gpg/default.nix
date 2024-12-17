{ pkgs, ... }: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  pinentryPackage = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gtk2;
in {
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
    inherit pinentryPackage;
  };
}
