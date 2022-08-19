{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.workstation;
in {
  options.my.system.workstation.enable = mkEnableOption "workstation";

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    users.extraGroups.networkmanager.members = [ "jamiez" ];

    services.fwupd.enable = true;
    services.pcscd.enable = true;
    services.printing.enable = true;

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.pathsToLink = [ "/share/zsh" ];

    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono"]; })
    ];

    console = {
      font = "JetBrainsMono Nerd Font";
      useXkbConfig = true;
    };

    my.system.docker = {
      enable = true;
      privilegedUsers = [ "jamiez" ];
    };
  };
}
