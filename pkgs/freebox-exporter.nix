{ lib, buildGoModule, fetchFromGitHub }: let
  pname = "freebox-exporter";
  version = "20241219";
in buildGoModule {
  inherit pname version;
  vendorHash = "sha256-zLhvFzkgUcBBRoowH5k/PJwl3uxtFZh3kl4kJN6mYjk=";

  src = fetchFromGitHub {
    owner = "trazfr";
    repo = pname;
    rev = "dfe0412606de4cf0ae192b1596ed58777159c78e";
    sha256 = "sha256-38UtcJ3R6TTVqbIyVIskUpR9yFzq9h9Xr7JeLNvA5QI=";
  };

  meta = with lib; {
    description = "Prometheus exporter for the Freebox";
    homepage    = "https://github.com/trazfr/freebox-exporter";
    license     = licenses.mit;
  };
}
