{ pkgs, ... }:
{
  users.users.sev = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ firefox-wayland ];
  };
}
