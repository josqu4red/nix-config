{ lib, grafanaPlugins }:

grafanaPlugins.grafanaPlugin {
  pname = "grafana-strava-datasource";
  version = "1.7.2";
  zipHash = {
    aarch64-linux = "sha256-L6RuqdygxLiLDfosYCMqjCJEP3+BT4chURGk2D2YGhw=";
    x86_64-linux = "sha256-7l+GuXwKeikql2F62EUc52Mv0qhmC1IvsCGzFK1cm0g=";
  };
  meta = with lib; {
    description = "Visualize your sport activity with Grafana.";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
