{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;

  inherit (builtins) concatStringsSep hashString map match pathExists split substring;
  inherit (nixpkgs.lib) filterAttrs nameValuePair nixosSystem optional optionalAttrs;
  inherit (nixpkgs.lib.misc) mergeAttrsWithFunc;
  inherit (nixpkgs.lib.lists) flatten isList remove unique;
  inherit (nixpkgs.lib.attrsets) concatMapAttrs genAttrs listToAttrs mapAttrs;
  inherit (home-manager.lib) homeManagerConfiguration;

  secrets = import ../secrets/build;

  ifExists = path:
    optional (pathExists path) path;

  forAllSystems = genAttrs [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];

  filterSystem = system: (filterAttrs (k: v: (match ".*-${system}" v.system) == []));

  machineId = hostname: hashString "md5" hostname;

  macAddress = hostname: let
    idEnd = substring 26 6 (machineId hostname);
    firstBytes = "02:de:ad";
    lastBytes = concatStringsSep ":" (remove "" (flatten (split "([[:alnum:]]{2})" idEnd)));
  in concatStringsSep ":" [firstBytes lastBytes];

  setDefaults = mergeAttrsWithFunc (a: b: if isList(a) then (unique (a ++ b)) else b);

  expandFacts = facts: mapAttrs (hostname: v: setDefaults facts.defaults v) facts.hosts;

  buildNixosConfigs = mapAttrs (hostname: hostFacts: let
    pkgsCross = optionalAttrs (hostFacts.system == "aarch64-linux")
                  { pkgsCross = self.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform; };
  in nixosSystem {
      pkgs = self.legacyPackages.${hostFacts.system};
      specialArgs = { inherit self inputs hostname hostFacts secrets; } // pkgsCross;
      modules = [ self.nixosModules.default ../secrets/build/facts.nix ]
                ++ ifExists ../hosts/${hostname}
                ++ map (u: ../users/${u}) hostFacts.users;
    }
  );

  buildHomeConfigs = concatMapAttrs (hostname: v: let
    pkgs = self.legacyPackages.${v.system};
  in listToAttrs (map (username:
      nameValuePair "${username}@${hostname}" (homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username; inherit (v) stateVersion; };
        modules = [ ../users/${username}/home.nix ]
                  ++ ifExists ../users/${username}/${hostname}.nix;
      })
    ) v.users)
  );
in { inherit buildHomeConfigs buildNixosConfigs expandFacts filterSystem forAllSystems machineId macAddress; }
