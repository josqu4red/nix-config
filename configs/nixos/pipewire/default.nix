{ pkgs, ... }: {
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  environment.systemPackages = with pkgs; [ pulseaudio pamixer ];
}
