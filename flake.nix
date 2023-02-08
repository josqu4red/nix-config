{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    custom-nixpkgs.url = "github:josqu4red/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = inputs:
  let
    lib = import ./lib { inherit inputs; };
    inherit (lib) forAllSystems mapHomes mkSystem;

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
  in {
    inherit legacyPackages;

    nixosConfigurations = let
      system = "x86_64-linux";
      pkgs = legacyPackages.${system};
    in {
      boson = mkSystem { hostname = "boson"; profile = "desktop"; users = [ "jamiez" ]; inherit pkgs; };
      neutrino = mkSystem { hostname = "neutrino"; profile = "laptop"; users = [ "jamiez" ]; inherit pkgs; };
      quark = mkSystem { hostname = "quark"; profile = "laptop"; users = [ "jamiez" "sev" ]; inherit pkgs; };
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
