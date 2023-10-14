{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (self) outputs;

  inherit (builtins) attrNames attrValues listToAttrs pathExists;
  inherit (nixpkgs.lib) nixosSystem filterAttrs flatten genAttrs nameValuePair optional;
  inherit (home-manager.lib) homeManagerConfiguration;
in
rec {
  stateVersion = "22.05";
  systems = [ "aarch64-linux" "x86_64-linux" ];

  forAllSystems = genAttrs systems;

  ifExists = path:
    optional (pathExists path) path;

  mkSystem =
    { hostname
    , profile
    , users ? []
    , pkgs
    , extraArgs ? {}
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs outputs hostname stateVersion users; } // extraArgs;
      modules = attrValues (import ../modules/options)
                ++ attrValues (import ../modules/system)
                ++ [ ../profiles/${profile} ]
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) users;
    };

  hostUsers = host:
    attrNames (filterAttrs (_n: v: v.isNormalUser) outputs.nixosConfigurations.${host}.config.users.users);

  mapHomes = { pkgs }: listToAttrs (flatten(
    map (hostname:
      map (username:
        nameValuePair "${username}@${hostname}" (mkHome { inherit username hostname pkgs; })
      ) (hostUsers hostname)
    ) (attrNames outputs.nixosConfigurations)
  ));

  mkHome =
    { username
    , hostname
    , pkgs
    }:
    homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          home = {
            inherit username stateVersion;
            homeDirectory = "/home/${username}";
          };
        }
        ../users/${username}/home.nix
      ]
      ++ attrValues (import ../modules/home)
      ++ ifExists ../users/${username}/${hostname}.nix;
    };
}
