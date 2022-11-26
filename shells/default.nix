{ pkgs }:
{
  arduino = import ./arduino.nix { inherit pkgs; };
  go = import ./go.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
}
