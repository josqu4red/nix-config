{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, python3
}: let
  owner = "hekmon";
  repo = "rtetempo";
  version = "1.3.2";
in buildHomeAssistantComponent {
  inherit owner version;
  domain = repo;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "refs/tags/v${version}";
    hash = "sha256-MLZeX6WNUSgVEv8zapAkkBKY5R1l5ykCcWTleYF0H5o=";
  };

  propagatedBuildInputs = with python3.pkgs; [ requests-oauthlib ];

  meta = with lib; {
    changelog = "https://github.com/hekmon/rtetempo/releases/tag/v${version}";
    description = "RTE Tempo days calendar and sensors for Home Assistant ";
    homepage = "https://github.com/hekmon/rtetempo";
    license = licenses.mit;
  };
}
