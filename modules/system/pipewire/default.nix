{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.system.pipewire;
in {
  options.my.system.pipewire = {
    enable = mkEnableOption "pipewire";
  };
  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    environment.systemPackages = with pkgs; [ pulseaudio pamixer ];
  };
}
