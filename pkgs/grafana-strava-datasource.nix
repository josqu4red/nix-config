{ lib, grafanaPlugins }:

grafanaPlugins.grafanaPlugin {
  pname = "grafana-strava-datasource";
  version = "1.7.2";
  zipHash = {
    aarch64-linux = "sha256-L6RuqdygxLiLDfosYCMqjCJEP3+BT4chURGk2D2YGhw=";
  };
  meta = with lib; {
    description = "Visualize your sport activity with Grafana.";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
