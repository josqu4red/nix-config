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
    ssh-to-pgp = {
      url = "github:Mic92/ssh-to-pgp?rev=c175033ca42c116939a3decb2a6461b7396c9bb1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:josqu4red/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    lib = import ./lib { inherit inputs; };
    inherit (import ./secrets/build/facts.nix {}) facts;
    inherit (lib) buildHomeConfigs buildNixosConfigs expandFacts filterSystem forAllSystems;

    hosts = expandFacts facts;

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

    nixosConfigurations = buildNixosConfigs (filterSystem "linux" hosts);
    nixosModules = import ./modules/nixos;
    nixosProfiles = import ./modules/profiles;

    homeConfigurations = buildHomeConfigs hosts;
    homeModules = import ./modules/home-manager;

    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = legacyPackages.${system};
                                     sops-import-keys-hook = inputs.sops-nix.packages.${system}.sops-import-keys-hook;
                                     ssh-to-pgp = inputs.ssh-to-pgp.packages.${system}.ssh-to-pgp; };
      fhsEnv = import ./pkgs/fhsEnv.nix { pkgs = legacyPackages.${system}; };
    });

    packages = forAllSystems (system: let
        pkgs = legacyPackages.${system};
    in {
      nixlive = self.nixosConfigurations.nixlive.config.system.build.isoImage;
      doc = pkgs.callPackage ./pkgs/doc.nix {};
    });
  };
}
