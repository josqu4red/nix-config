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

    pkgs = legacyPackages."x86_64-linux";
    aarch64-pkgs = legacyPackages."aarch64-linux";
  in {
    inherit legacyPackages;

    nixosConfigurations = {
      boson = mkSystem { hostname = "boson"; profile = "desktop"; users = [ "jamiez" ]; inherit pkgs; };
      charm = mkSystem { hostname = "charm"; profile = "server"; users = [ "jamiez" ]; pkgs = aarch64-pkgs;
                            extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; };
      neutrino = mkSystem { hostname = "neutrino"; profile = "laptop"; users = [ "jamiez" ]; inherit pkgs; };
      quark = mkSystem { hostname = "quark"; profile = "laptop"; users = [ "jamiez" "sev" ]; inherit pkgs; };
      tau = mkSystem { hostname = "tau"; profile = "server"; users = [ "jamiez" ]; inherit pkgs; };
    };

    homeConfigurations = mapHomes { inherit pkgs; };

    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = legacyPackages.${system}; };
    });
  };
}
