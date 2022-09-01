{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (self) outputs;

  inherit (builtins) elemAt match any attrValues pathExists;
  inherit (nixpkgs.lib) nixosSystem genAttrs mapAttrs' optional;
  inherit (home-manager.lib) homeManagerConfiguration;
in
rec {
  # Applies a function to a attrset's names, while keeping the values
  mapAttrNames = f: mapAttrs' (name: value: { name = f name; inherit value; });

  has = element: any (x: x == element);

  getUsername = string: elemAt (match "(.*)@(.*)" string) 0;
  getHostname = string: elemAt (match "(.*)@(.*)" string) 1;

  systems = [
    "aarch64-linux"
    "x86_64-linux"
  ];
  forAllSystems = genAttrs systems;

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
                ++ [ ../hosts/${hostname} ]
                ++ map (u: ../users/${u}) users;
    };

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
                     ++ optional (pathExists ../users/${username}/${hostname}.nix) ../users/${username}/${hostname}.nix;
      configuration = ../users/${username}/home.nix ;
    };
}
