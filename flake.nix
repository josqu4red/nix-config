# sudo nixos-rebuild switch --flake /etc/nixos
# sudo nix flake update --commit-lock-file /etc/nixos

{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    nixosConfigurations.boson = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Things in this set are passed to modules and accessible
      # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
      #   specialArgs = {
      #     inherit inputs;
      #   };
      modules = [
        ./hosts/boson/hardware.nix
        ./modules/base.nix
        ./modules/workstation.nix
        ./hosts/boson/configuration.nix

        inputs.home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nix.extraOptions = "experimental-features = nix-command flakes";
          nix.package = pkgs.nixFlakes;
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.users.jamiez = import ./hosts/boson/home.nix;
        })
      ];
    };
    nixosConfigurations.neutrino = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Things in this set are passed to modules and accessible
      # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
      #   specialArgs = {
      #     inherit inputs;
      #   };
      modules = [
        ./hosts/neutrino/hardware.nix
        ./modules/base.nix
        ./modules/workstation.nix
        ./hosts/neutrino/configuration.nix

        inputs.home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nix.extraOptions = "experimental-features = nix-command flakes";
          nix.package = pkgs.nixFlakes;
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.users.jamiez = import ./hosts/neutrino/home.nix;
        })
      ];
    };
  };
}
