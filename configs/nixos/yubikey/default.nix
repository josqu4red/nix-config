{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ yubikey-manager yubikey-personalization yubikey-personalization-gui yubico-piv-tool yubioath-desktop ];
  services.udev.packages = [ pkgs.yubikey-personalization ];
}
