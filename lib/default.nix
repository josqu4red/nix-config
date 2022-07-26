{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (self) outputs;

  inherit (builtins) attrNames attrValues listToAttrs pathExists;
  inherit (nixpkgs.lib) nixosSystem filterAttrs flatten genAttrs nameValuePair optional;
  inherit (home-manager.lib) homeManagerConfiguration;
in
rec {
  systems = [
    "aarch64-linux"
    "x86_64-linux"
  ];
  forAllSystems = genAttrs systems;

  ifExists = path:
    optional (pathExists path) path;

  mkSystem =
    { hostname
    , users ? []
    , pkgs
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs outputs hostname; };
      modules = attrValues (import ../modules/system)
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) users;
    };

  hostUsers = host:
    attrNames (filterAttrs (_n: v: v.isNormalUser) outputs.nixosConfigurations.${host}.config.users.users);

  mapHomes = listToAttrs (flatten(
    map (hostname:
      map (username:
        nameValuePair "${username}@${hostname}" (mkHome { inherit username hostname; })
      ) (hostUsers hostname)
    ) (attrNames outputs.nixosConfigurations)
  ));

  mkHome =
    { username
    , hostname ? null
    , pkgs ? outputs.nixosConfigurations.${hostname}.pkgs
    , features ? [ ]
    }:
    homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs outputs hostname username features;
      };
      modules = [
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.05";
          };
        }
        ../users/${username}/home.nix
      ]
      ++ attrValues (import ../modules/home)
      ++ ifExists ../users/${username}/${hostname}.nix;
    };
}
