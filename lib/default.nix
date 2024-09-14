{ inputs, ... }:
let
  inherit (inputs) self home-manager impermanence nixpkgs sops-nix;
  inherit (self) outputs;

  inherit (builtins) map pathExists;
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
    , users ? []
    , pkgs
    , extraArgs ? {}
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs outputs hostname stateVersion users; } // extraArgs;
      modules = [ self.nixosModules.default
                  impermanence.nixosModules.impermanence
                  sops-nix.nixosModules.sops ]
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
      extraSpecialArgs = { inherit inputs username stateVersion; };
      modules = [ ../users/${username}/home.nix ]
                ++ ifExists ../users/${username}/${hostname}.nix;
    };
}
