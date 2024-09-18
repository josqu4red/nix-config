{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs sops-nix;

  inherit (builtins) concatStringsSep hashString map pathExists split substring;
  inherit (nixpkgs.lib) nixosSystem genAttrs optional;
  inherit (nixpkgs.lib.lists) flatten remove;
  inherit (home-manager.lib) homeManagerConfiguration;

  ifExists = path:
    optional (pathExists path) path;

  stateVersion = "22.05";

  forAllSystems = genAttrs [ "aarch64-linux" "x86_64-linux" ];

  machineId = hostname: hashString "md5" hostname;

  macAddress = hostname: let
    idEnd = substring 26 6 (machineId hostname);
    firstBytes = "02:de:ad";
    lastBytes = concatStringsSep ":" (remove "" (flatten (split "([[:alnum:]]{2})" idEnd)));
  in concatStringsSep ":" [firstBytes lastBytes];
in {
  inherit forAllSystems machineId macAddress;

  mkSystem =
    { hostname
    , users ? []
    , pkgs
    , extraArgs ? {}
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = { inherit self inputs hostname stateVersion users; } // extraArgs;
      modules = [ self.nixosModules.default
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
