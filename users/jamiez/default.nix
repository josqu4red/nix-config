{ config, hostname, ... }: let
  secrets = import ./secrets;
in {
  programs.zsh.enable = builtins.match "^zsh-.*" config.custom.userShell.name != null;
  users.users.jamiez = {
    isNormalUser = true;
    shell = config.custom.userShell;
    extraGroups = [ "wheel" "audio" "dialout" "video" ];
    hashedPassword = secrets.password hostname;
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };
}
