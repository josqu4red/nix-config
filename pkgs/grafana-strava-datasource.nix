{ lib, grafanaPlugins }:

let
  pname = "grafana-strava-datasource";
  version = "1.7.2";
  url =
    arch: "https://grafana.com/api/plugins/${pname}/versions/${version}/download?os=linux&arch=${arch}";
in
grafanaPlugins.grafanaPlugin {
  inherit pname version;
  packages = {
    linux-arm64 = {
      url = url "arm64";
      hash = "sha256-L6RuqdygxLiLDfosYCMqjCJEP3+BT4chURGk2D2YGhw=";
    };
    linux-amd64 = {
      url = url "amd64";
      hash = "sha256-7l+GuXwKeikql2F62EUc52Mv0qhmC1IvsCGzFK1cm0g=";
    };
  };
  meta = with lib; {
    description = "Visualize your sport activity with Grafana.";
    license = licenses.mit;
  };
}
