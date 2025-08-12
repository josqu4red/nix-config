{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, python313
}: let
  owner = "vingerha";
  version = "0.5.6.3";
  domain = "gtfs2";
in buildHomeAssistantComponent {
  inherit owner version domain;

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/${version}";
    hash = "sha256-k6LV6/gdlZXJusDUf1GnYsO8yTl5N1BrSavJCr7sSwE=";
  };

  propagatedBuildInputs = with python313.pkgs; [ pygtfs gtfs-realtime-bindings protobuf ];

  meta = with lib; {
    changelog = "https://github.com/vingerha/gtfs2/releases/tag/${version}";
    description = "Support GTFS in Home Assistant GUI-only";
    homepage = "https://github.com/vingerha/gtfs2";
    license = licenses.mit;
  };
}
