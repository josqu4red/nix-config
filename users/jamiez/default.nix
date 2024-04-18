{ config, ... }:
{
  programs.zsh.enable = builtins.match "^zsh-.*" config.custom.userShell.name != null;
  users.users.jamiez = {
    isNormalUser = true;
    shell = config.custom.userShell;
    extraGroups = [ "wheel" "audio" "dialout" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAXrdtanxjtuV1lJJuIkazGnF7y07i9MkiRekXZCcfu jamiez@whrvr"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINVNKxoDLzRrWO6cUTQspJ5BlaaS2IoHe+3SESYohr2J jamiez@boson"
    ];
  };
}
