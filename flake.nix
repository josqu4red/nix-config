# sudo nixos-rebuild switch --flake /etc/nixos
# sudo nix flake update --commit-lock-file /etc/nixos

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
    inherit (lib) forAllSystems mkHome mkSystem;

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

    nixosConfigurations = {
      boson = mkSystem { hostname = "boson"; pkgs = legacyPackages.x86_64-linux; system = "x86_64-linux"; };
      neutrino = mkSystem { hostname = "neutrino"; pkgs = legacyPackages.x86_64-linux; system = "x86_64-linux"; };
    };

    homeConfigurations = {
      "jamiez@boson" = mkHome { username = "jamiez"; hostname = "boson"; };
      "jamiez@neutrino" = mkHome { username = "jamiez"; hostname = "neutrino"; };
    };

    devShells = forAllSystems (system: {
      #default = import ./shells/nix.nix { inherit pkgs; } # TODO
      go = import ./shells/go.nix { pkgs = legacyPackages; };
      python = import ./shells/python.nix { pkgs = legacyPackages; };
    });
  };
}
