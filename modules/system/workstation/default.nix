{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.workstation;
in {
  options.my.system.workstation.enable = mkEnableOption "workstation";

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.networkmanager.enable = true;
    networking.resolvconf.enable = false;
    services.resolved.enable = true;
    users.extraGroups.networkmanager.members = [ "jamiez" ];

    security.sudo.wheelNeedsPassword = false;

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

    fonts.fonts = with pkgs; [ jetbrains-mono ];

    console.useXkbConfig = true;

    my.system = {
      cli-tools.enable = true;
      docker = {
        enable = true;
        privilegedUsers = [ "jamiez" ];
      };
    };
  };
}
