{ inputs, pkgs, users, ... }: {
  imports = [ ../base ]
    ++ (with inputs.self.nixosConfigs; [ desktop pipewire ]);

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  services.udisks2.enable = true;

  networking.networkmanager.enable = true;
  networking.resolvconf.enable = false;
  services.resolved.enable = true;
  users.extraGroups.networkmanager.members = users;

  services.fwupd.enable = true;
  services.pcscd.enable = true;
  services.printing.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  time.timeZone = "Europe/Paris";

  console.useXkbConfig = true;

  custom.userShell = pkgs.zsh;
}
