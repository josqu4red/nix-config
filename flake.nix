{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
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
  {
    inherit legacyPackages;

    nixosConfigurations = let
      system = "x86_64-linux";
      pkgs = legacyPackages.${system};
    in
    {
      boson = mkSystem { hostname = "boson"; users = [ "jamiez" ]; inherit system pkgs; };
      neutrino = mkSystem { hostname = "neutrino"; users = [ "jamiez" ]; inherit system pkgs; };
    };

    homeConfigurations = mapHomes;

    devShells = forAllSystems (system: {
      #default = import ./shells/nix.nix { inherit pkgs; } # TODO
      go = import ./shells/go.nix { pkgs = legacyPackages.${system}; };
      python = import ./shells/python.nix { pkgs = legacyPackages.${system}; };
    });
  };
}
