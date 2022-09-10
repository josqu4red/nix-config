{ stdenv, fetchFromGitHub, lib }:
stdenv.mkDerivation {
  name = "gws";

  src = fetchFromGitHub {
    owner = "StreakyCobra";
    repo = "gws";
    rev = "0.2.0";
    sha256 = "sha256-/m7b0m8RHouL6Gppca3f7G4aIy3sJ1kkYQGGNh9ZkMc=";
  };

  installPhase = ''
    install -Dm 0755 $src/src/gws $out/bin/gws
    install -Dm 0644 completions/bash $out/share/bash-completion/completions/gws
    install -Dm 0644 completions/zsh $out/share/zsh/site-functions/_gws
  '';

  meta = with lib; {
    description = "gws is a KISS, bash, colorful helper to manage workspaces composed of Git repositories.";
    homepage    = "https://github.com/StreakyCobra/gws";
    license     = licenses.mit;
  };
}
