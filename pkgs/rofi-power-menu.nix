{ stdenv, fetchFromGitHub }:
let
  pname = "rofi-power-menu";
  version = "3.1.0";
  sha256 = "sha256-VPCfmCTr6ADNT7MW4jiqLI/lvTjlAu1QrCAugiD0toU=";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "jluttine";
    repo = pname;
    rev = version;
    inherit sha256;
  };

  installPhase = ''
    install -Dm755 rofi-power-menu $out/bin/rofi-power-menu
  '';
}
