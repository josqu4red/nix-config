{ ... }: {
  imports = [
    ../base
  ];

  time.timeZone = "UTC";

  services.timesyncd.enable = true;

  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing

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

}