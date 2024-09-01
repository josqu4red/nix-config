{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, python3
}: let
  owner = "rstrouse";
  version = "2.4.7";
in buildHomeAssistantComponent {
  inherit owner version;
  domain = "espsomfy_rts";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ESPSomfy-RTS-HA";
    rev = "refs/tags/v${version}";
    hash = "sha256-F0cWvkTHexCHR1Pcp8jlNJpBAdzfC5Yk/7H2i8wj/u0=";
  };

  propagatedBuildInputs = with python3.pkgs; [ aiofiles websocket-client ];

  meta = with lib; {
    changelog = "https://github.com/rstrouse/ESPSomfy-RTS-HA/releases/tag/${version}";
    description = "Control your somfy shades in Home Assistant";
    homepage = "https://github.com/rstrouse/ESPSomfy-RTS-HA";
    license = licenses.unlicense;
  };
}
