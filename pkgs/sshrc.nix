{ stdenv, fetchFromGitHub, lib, makeWrapper, coreutils, gnutar, gzip, openssh, openssl }:
let
  pname = "sshrc";
  rev = "46b92e29a11cfa867fcf0ecf7ac3b2a9374f87ce";
  sha256 = "sha256-bb7567fdsnLx4sLlJ0f4cYQV6U6BV+X3h5GDIPCivPA=";
in stdenv.mkDerivation {
  name = "${pname}-${rev}";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    inherit rev sha256;
  };

  installPhase = ''
    install -Dm 0755 $src/sshrc $out/bin/sshrc
  '';

  postFixup = ''
    wrapProgram $out/bin/sshrc --set PATH ${lib.makeBinPath [ coreutils gnutar gzip openssh openssl ]}
  '';

  meta = with lib; {
    description = "Bring your .bashrc, .vimrc, etc. with you when you ssh.";
    homepage    = "https://github.com/cdown/sshrc";
    license     = licenses.mit;
  };
}
