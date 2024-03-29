{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    defaultCacheTtl = 21600;
    maxCacheTtl = 43200;
    pinentryFlavor = "gnome3"; # "curses", "tty", "emacs", "gnome3", "qt"
  };
}
