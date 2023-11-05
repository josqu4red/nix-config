{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (self) outputs;

  inherit (builtins) attrValues listToAttrs map pathExists;
  inherit (nixpkgs.lib) nixosSystem genAttrs optional;
  inherit (home-manager.lib) homeManagerConfiguration;

  ifExists = path:
    optional (pathExists path) path;

  stateVersion = "22.05";
  systems = [ "aarch64-linux" "x86_64-linux" ];
in {
  forAllSystems = genAttrs systems;

  mkSystem =
    { hostname
    , profile
    , users ? []
    , pkgs
    , extraArgs ? {}
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs outputs hostname stateVersion users; nxConfPath = ../configs/nixos; } // extraArgs;
      modules = [ ../configs/profiles/${profile} ]
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) users;
    };

  mkHome =
    { username
    , hostname
    , pkgs
    }:
    homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { hmConfPath = ../configs/home-manager; };
      modules = [
        {
          home = {
            inherit username stateVersion;
            homeDirectory = "/home/${username}";
          };
        }
        ../users/${username}/home.nix
      ]
      ++ ifExists ../users/${username}/${hostname}.nix;
    };
}
