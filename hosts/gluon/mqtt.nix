{ config, ... }:
{
  nxmods.sops.secrets.mqtt.files."password" = {
    owner = "mosquitto";
    restartUnits = [ "mosquitto.service" ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.all = {
          acl = [ "readwrite #" ];
          passwordFile = config.sops.secrets."mqtt/password".path;
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];
}
