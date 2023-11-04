{ stdenv, fetchgit, lib, makeWrapper, coreutils }:
let
  pname = "fake-hwclock";
  version = "0.12";
in stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchgit {
    url = "https://git.einval.com/git/fake-hwclock.git";
    rev = "v${version}";
    hash = "sha256-8wsCSJe3x9Flr2Wc7Cu8VfQyhjs3eqrOa9rmjoDp2ig=";
  };

  installPhase = ''
    install -Dm 0755 $src/fake-hwclock $out/bin/fake-hwclock
  '';

  postFixup = ''
    wrapProgram $out/bin/fake-hwclock --set PATH ${lib.makeBinPath [ coreutils ]}
  '';

  meta = with lib; {
    description = "Save/restore system clock on machines without working RTC hardware";
    homepage    = "https://git.einval.com/cgi-bin/gitweb.cgi?p=fake-hwclock.git";
    license     = licenses.gpl2;
  };
}
