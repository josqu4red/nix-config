{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = builtins.attrValues {
    inherit (pkgs) go gotools gopls go-outline gocode gopkgs gocode-gomod godef golint;
  };

  shellHook = ''
    export GOPATH="$HOME/.go"
  '';
}
