{ lib, buildGoModule, fetchFromGitHub }: let
  pname = "freebox-exporter";
  version = "20240511";
in buildGoModule {
  inherit pname version;
  vendorHash = "sha256-plcup0y3XZjcXnng3k6pq7og7zSp95j/xKkb2FDbpZE=";

  src = fetchFromGitHub {
    owner = "trazfr";
    repo = pname;
    rev = "5ebf34620f1721dee0650e68c1d2332bb403bd64";
    sha256 = "sha256-J5MKdK2T1WR5qBCtlzkgF2gHSQQ4DUg9Yan8gxu270g=";
  };

  meta = with lib; {
    description = "Prometheus exporter for the Freebox";
    homepage    = "https://github.com/trazfr/freebox-exporter";
    license     = licenses.mit;
  };
}
