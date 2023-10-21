{ config, ... }:
{
  programs.zsh.enable = builtins.match "^zsh-.*" config.custom.userShell.name != null;
  users.users.jamiez = {
    isNormalUser = true;
    shell = config.custom.userShell;
    extraGroups = [ "wheel" "dialout" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAXrdtanxjtuV1lJJuIkazGnF7y07i9MkiRekXZCcfu jamiez@whrvr"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0iPZisp217gCwxTTizJ3HMbTIyRzYzAPDZA3kML2D2 jamiez@boson"
    ];
  };
}
