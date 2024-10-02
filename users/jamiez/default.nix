{ config, hostname, ... }: let
  secrets = import ../../secrets/build/jamiez.nix;
in {
  programs.zsh.enable = builtins.match "^zsh-.*" config.settings.userShell.name != null;
  users.users.jamiez = {
    isNormalUser = true;
    shell = config.settings.userShell;
    extraGroups = [ "wheel" "audio" "dialout" "video" ];
    hashedPassword = secrets.password hostname;
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };
}
