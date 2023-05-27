{ ... }:
{
  imports = [ ./hardware.nix ./sd-image.nix ];

  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing

  security.sudo.wheelNeedsPassword = false;

  services.chrony.enable = true;
}
