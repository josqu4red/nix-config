{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.services.fake-hwclock;
  fakeHwClockBin = "${pkgs.fake-hwclock}/bin/fake-hwclock";
  Environment = "FILE=/var/lib/fake-hwclock.state";
in {
  options.services.fake-hwclock = {
    enable = mkEnableOption "fake-hwclock service";
  };

  config = mkIf cfg.enable {
    systemd.services.fake-hwclock = {
      description = "Save/restore system clock on machines without working RTC hardware";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${fakeHwClockBin} load";
        ExecStop = "${fakeHwClockBin} save";
        RemainAfterExit = true;
        inherit Environment;
      };
    };

    systemd.services.fake-hwclock-save = {
      description = "Periodically save system time";
      after = [ "fake-hwclock.service" ];
      requires = [ "fake-hwclock.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${fakeHwClockBin} save";
        StandardOutput = "null";
        inherit Environment;
      };
    };

    systemd.timers.fake-hwclock-save = {
      description = "Periodically save system time";
      after = [ "fake-hwclock.service" ];
      wantedBy = [ "fake-hwclock.service" ];
      timerConfig = {
        OnActiveSec = "1h";
        OnUnitActiveSec = "1h";
      };
    };
  };
}
