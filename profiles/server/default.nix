{ ... }: {
  imports = [
    ../base
  ];

  time.timeZone = "UTC";

  nix.settings.trusted-users = [ "@wheel" ]; # TODO: figure out signing
}
