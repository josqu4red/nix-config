{ pkgs, ... }:
{
  users.users.sev = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      firefox-wayland
      libreoffice
      hunspell
      hunspellDicts.en_US
      hunspellDicts.fr-moderne
    ];
  };
}
