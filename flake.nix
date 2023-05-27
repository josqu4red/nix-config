{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ local-pkgs ];
      }
    );

    systemModules = attrValues (import ./modules/options)
                    ++ attrValues (import ./modules/system)
                    ++ [ inputs.disko.nixosModules.disko ];
  in {
    inherit legacyPackages;

    nixosConfigurations = let
      pkgs = legacyPackages."x86_64-linux";
      aarch64-pkgs = legacyPackages."aarch64-linux";
      mods = systemModules;
    in {
      boson = mkSystem { hostname = "boson"; profile = "desktop"; users = [ "jamiez" ]; inherit pkgs mods; };
      charm = mkSystem { hostname = "charm"; profile = "server"; users = [ "jamiez" ]; pkgs = aarch64-pkgs;
                            extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; inherit mods; };
      neutrino = mkSystem { hostname = "neutrino"; profile = "laptop"; users = [ "jamiez" ]; inherit pkgs mods; };
      quark = mkSystem { hostname = "quark"; profile = "laptop"; users = [ "jamiez" "sev" ]; inherit pkgs mods; };
      tau = mkSystem { hostname = "tau"; profile = "server"; users = [ "jamiez" ]; inherit pkgs mods; };
    };

    homeConfigurations = mapHomes;

    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = legacyPackages.${system}; };
    });
  };
}
