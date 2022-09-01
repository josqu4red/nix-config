{ config, pkgs, ... }:
{
  users.users.jamiez = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0iPZisp217gCwxTTizJ3HMbTIyRzYzAPDZA3kML2D2 jamiez@boson"
    ];
  };
}
