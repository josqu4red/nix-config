# sudo nixos-rebuild switch --flake /etc/nixos
# sudo nix flake update --commit-lock-file /etc/nixos

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
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
        ./hardware-configuration.nix
        ./configuration.nix

        inputs.home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nix.extraOptions = "experimental-features = nix-command flakes";
          nix.package = pkgs.nixFlakes;
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.users.jamiez = import ./home.nix;
        })
      ];
    };
  };
}
