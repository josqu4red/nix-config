{ ... }: {
  imports = [
    ../base
  ];

  time.timeZone = "UTC";

  services.timesyncd.enable = true;

  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing
}
