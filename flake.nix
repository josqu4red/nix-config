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
    inherit (lib) forAllSystems mkSystem mkHome;
    inherit (builtins) listToAttrs;
    inherit (nixpkgs.lib) flatten nameValuePair;

    local-pkgs = final: _prev: import ./pkgs { pkgs = final; };

    legacyPackages = forAllSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ local-pkgs ];
      }
    );

    pkgs = legacyPackages."x86_64-linux";
    aarch64-pkgs = legacyPackages."aarch64-linux";

    hosts = [
      { hostname = "boson"; users = [ "jamiez" ]; inherit pkgs; }
      { hostname = "charm"; users = [ "jamiez" ]; pkgs = aarch64-pkgs;
        extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; }
      { hostname = "electron"; users = [ "jamiez" ]; pkgs = aarch64-pkgs;
        extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; }
      { hostname = "neutrino"; users = [ "jamiez" ]; inherit pkgs; }
      { hostname = "quark"; users = [ "jamiez" "sev" ]; inherit pkgs; }
      { hostname = "tau"; users = [ "jamiez" ]; inherit pkgs; }
      { hostname = "nixlive"; users = [ "jamiez" ]; inherit pkgs; }
    ];
  in {
    inherit legacyPackages lib;

    nixosModules = import ./modules/nixos;
    nixosProfiles = import ./modules/profiles;
    homeModules = import ./modules/home-manager;

    nixosConfigurations = listToAttrs (map (h: nameValuePair h.hostname (mkSystem h)) hosts);

    homeConfigurations = listToAttrs (flatten(
      map (host:
        map (username:
          nameValuePair "${username}@${host.hostname}" (mkHome { inherit (host) hostname; inherit username pkgs; })
        ) host.users
      ) hosts
    ));

    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = legacyPackages.${system};
                                     sops-import-keys-hook = inputs.sops-nix.packages.${system}.sops-import-keys-hook; };
    });

    packages.x86_64-linux = {
      nixlive = self.nixosConfigurations.nixlive.config.system.build.isoImage;
    };
  };
}
