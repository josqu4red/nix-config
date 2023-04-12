{ config, ... }:
{
  programs.zsh.enable = config.my.options.userShell.pname == "zsh";
  users.users.jamiez = {
    isNormalUser = true;
    shell = config.my.options.userShell;
    extraGroups = [ "wheel" "dialout" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAXrdtanxjtuV1lJJuIkazGnF7y07i9MkiRekXZCcfu jamiez@whrvr"
    ];
  };
}
