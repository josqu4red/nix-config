{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:josqu4red/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    lib = import ./lib { inherit inputs; };
    inherit (import ./secrets/build/facts.nix {}) facts;
    inherit (lib) forAllSystems buildHomeConfigs buildNixosConfigs;

    local-pkgs = final: _prev: import ./pkgs { pkgs = final; };

    legacyPackages = forAllSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ local-pkgs ];
      }
    );
  in {
    inherit facts legacyPackages lib;

    nixosConfigurations = buildNixosConfigs facts;
    nixosModules = import ./modules/nixos;
    nixosProfiles = import ./modules/profiles;

    homeConfigurations = buildHomeConfigs facts;
    homeModules = import ./modules/home-manager;

    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = legacyPackages.${system};
                                     sops-import-keys-hook = inputs.sops-nix.packages.${system}.sops-import-keys-hook; };
    });

    packages.x86_64-linux = {
      nixlive = self.nixosConfigurations.nixlive.config.system.build.isoImage;
    };
  };
}
