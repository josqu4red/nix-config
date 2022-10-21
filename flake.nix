{
  inputs = {
    nixpkgs.url = "path:/home/jamiez/code/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
  let
    lib = import ./lib { inherit inputs; };
    inherit (lib) forAllSystems mapHomes mkSystem;

    overlay = final: _prev: import ./pkgs { pkgs = final; };

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlay ];
      }
    );
  in
  rec {
    inherit legacyPackages;

    nixosConfigurations = let
      system = "x86_64-linux";
      pkgs = legacyPackages.${system};
    in
    {
      boson = mkSystem { hostname = "boson"; users = [ "jamiez" ]; inherit pkgs; };
      neutrino = mkSystem { hostname = "neutrino"; users = [ "jamiez" ]; inherit pkgs; };
      lepotato = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./modules/system/sshd.nix
          ./users/jamiez
          ./hosts/lepotato
        ];
      };
    };

    homeConfigurations = mapHomes;

    devShells = forAllSystems (system:
      import ./shells { pkgs = legacyPackages.${system}; }
    );

    packages = forAllSystems (system:
      import ./pkgs { pkgs = legacyPackages.${system}; }
    );

    images.lepotato = nixosConfigurations.lepotato.config.system.build.sdImage;
  };
}
