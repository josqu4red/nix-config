{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;

  inherit (builtins) concatStringsSep hashString map pathExists split substring;
  inherit (nixpkgs.lib) nameValuePair nixosSystem optional optionals optionalAttrs;
  inherit (nixpkgs.lib.lists) flatten remove;
  inherit (nixpkgs.lib.attrsets) concatMapAttrs genAttrs hasAttr listToAttrs mapAttrs;
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

  buildNixosConfigs = facts: mapAttrs (hostname: v: let
    system  = v.system or facts.defaultSystem;
    pkgs = self.legacyPackages.${system};
    pkgsCross = self.legacyPackages.${facts.defaultSystem}.pkgsCross.aarch64-multiplatform;
    users = facts.defaultUsers ++ optionals (hasAttr "users" v) v.users;
    extraArgs = { hostFacts = v; } // optionalAttrs (system == "aarch64-linux") { inherit pkgsCross; };
  in nixosSystem {
      inherit pkgs;
      specialArgs = { inherit self inputs hostname stateVersion users; } // extraArgs;
      modules = [ self.nixosModules.default ../secrets/build/facts.nix ]
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) users;
    }
  ) facts.hosts;

  buildHomeConfigs = facts: concatMapAttrs (hostname: v: let
    system  = v.system or facts.defaultSystem;
    pkgs = self.legacyPackages.${system};
    users = facts.defaultUsers ++ optionals (hasAttr "users" v) v.users;
  in listToAttrs (map (username:
      nameValuePair "${username}@${hostname}" (homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username stateVersion; };
        modules = [ ../users/${username}/home.nix ]
                  ++ ifExists ../users/${username}/${hostname}.nix;
      })
    ) users)
  ) facts.hosts;
in { inherit buildHomeConfigs buildNixosConfigs forAllSystems machineId macAddress; }
