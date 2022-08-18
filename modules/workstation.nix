{ config, pkgs, ... }: {
  config = {
    nixpkgs.config.allowUnfree = true;

    networking.networkmanager.enable = true;
    users.extraGroups.networkmanager.members = [ "jamiez" ];

    time.timeZone = "Europe/Paris";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.utf8";
      LC_IDENTIFICATION = "fr_FR.utf8";
      LC_MEASUREMENT = "fr_FR.utf8";
      LC_MONETARY = "fr_FR.utf8";
      LC_NAME = "fr_FR.utf8";
      LC_NUMERIC = "fr_FR.utf8";
      LC_PAPER = "fr_FR.utf8";
      LC_TELEPHONE = "fr_FR.utf8";
      LC_TIME = "fr_FR.utf8";
    };

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
  };
}
