{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    custom-nixpkgs.url = "github:josqu4red/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
  let
    lib = import ./lib { inherit inputs; };
    inherit (lib) forAllSystems mapHomes mkSystem;
    inherit (builtins) attrValues;

    local-pkgs = final: _prev: import ./pkgs { pkgs = final; };
    custom-pkgs = system: _final: _prev: {
      custom-pkgs = import inputs.custom-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (custom-pkgs system) local-pkgs ];
      }
    );

    systemModules = attrValues (import ./modules/options)
                    ++ attrValues (import ./modules/system)
                    ++ [ inputs.disko.nixosModules.disko ];
  in {
    inherit legacyPackages;

    nixosConfigurations = let
      system = "x86_64-linux";
      pkgs = legacyPackages.${system};
      mods = systemModules;
    in {
      boson = mkSystem { hostname = "boson"; profile = "desktop"; users = [ "jamiez" ]; inherit pkgs mods; };
      neutrino = mkSystem { hostname = "neutrino"; profile = "laptop"; users = [ "jamiez" ]; inherit pkgs mods; };
      quark = mkSystem { hostname = "quark"; profile = "laptop"; users = [ "jamiez" "sev" ]; inherit pkgs mods; };
      tau = mkSystem { hostname = "tau"; profile = "server"; users = [ "jamiez" ]; inherit pkgs mods; };
    };

    homeConfigurations = mapHomes;

    devShells = forAllSystems (system:
      import ./shells { pkgs = legacyPackages.${system}; }
    );

    packages = forAllSystems (system:
      import ./pkgs { pkgs = legacyPackages.${system}; }
    );
  };
}
