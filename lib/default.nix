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
    , system
    }:
    nixosSystem {
      inherit pkgs system;
      specialArgs = { inherit inputs outputs hostname; };
      modules = attrValues (import ../modules/system)
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) users;
    };

  hostUsers = host:
    attrNames (filterAttrs (n: v: v.isNormalUser) outputs.nixosConfigurations.${host}.config.users.users);

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
    , system ? outputs.nixosConfigurations.${hostname}.system
    , features ? [ ]
    }:
    homeManagerConfiguration {
      inherit pkgs system username;
      extraSpecialArgs = {
        inherit inputs outputs hostname username features;
      };
      homeDirectory = "/home/${username}";
      extraModules = attrValues (import ../modules/home)
                     ++ ifExists ../users/${username}/${hostname}.nix;
      configuration = ../users/${username}/home.nix ;
    };
}
