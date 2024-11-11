{ secrets, ... }: {
  imports = [
    ../base
  ];

  time.timeZone = "UTC";

  services.timesyncd.enable = true;

  programs.bash.shellAliases = {
    l = "ls -lh";
    la = "ls -Alh";
    rr = "rm -rf";
    md = "mkdir -p";
    rd = "rmdir";
    j = "sudo journalctl";
    s = "sudo systemctl";
    sudo = "sudo ";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = secrets.acme-email;
  };
}
