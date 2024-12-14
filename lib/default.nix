{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;

  inherit (builtins) concatStringsSep hashString map pathExists split substring;
  inherit (nixpkgs.lib) isList nameValuePair nixosSystem optional optionalAttrs;
  inherit (nixpkgs.lib.misc) mergeAttrsWithFunc;
  inherit (nixpkgs.lib.lists) flatten remove unique;
  inherit (nixpkgs.lib.attrsets) concatMapAttrs genAttrs listToAttrs mapAttrs;
  inherit (home-manager.lib) homeManagerConfiguration;

  secrets = import ../secrets/build;

  ifExists = path:
    optional (pathExists path) path;

  forAllSystems = genAttrs [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];

  machineId = hostname: hashString "md5" hostname;

  macAddress = hostname: let
    idEnd = substring 26 6 (machineId hostname);
    firstBytes = "02:de:ad";
    lastBytes = concatStringsSep ":" (remove "" (flatten (split "([[:alnum:]]{2})" idEnd)));
  in concatStringsSep ":" [firstBytes lastBytes];

  setDefaults = mergeAttrsWithFunc (a: b: if isList(a) then (unique (a ++ b)) else b);

  buildNixosConfigs = facts: mapAttrs (hostname: v: let
    hostFacts = setDefaults facts.defaults v;
    pkgs = self.legacyPackages.${hostFacts.system};
    pkgsCross = self.legacyPackages.${facts.defaults.system}.pkgsCross.aarch64-multiplatform;

    extraArgs = { inherit hostFacts; } // optionalAttrs (hostFacts.system == "aarch64-linux") { inherit pkgsCross; };
  in nixosSystem {
      inherit pkgs;
      specialArgs = { inherit self inputs hostname secrets; } // extraArgs;
      modules = [ self.nixosModules.default ../secrets/build/facts.nix ]
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) hostFacts.users;
    }
  ) facts.hosts;

  buildHomeConfigs = facts: concatMapAttrs (hostname: v: let
    hostFacts = setDefaults v facts.defaults;
    pkgs = self.legacyPackages.${hostFacts.system};
  in listToAttrs (map (username:
      nameValuePair "${username}@${hostname}" (homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username; inherit (hostFacts) stateVersion; };
        modules = [ ../users/${username}/home.nix ]
                  ++ ifExists ../users/${username}/${hostname}.nix;
      })
    ) hostFacts.users)
  ) facts.hosts;
in { inherit buildHomeConfigs buildNixosConfigs forAllSystems machineId macAddress; }
