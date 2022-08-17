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

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations =
      let
        system = "x86_64-linux";

        mkLinuxSystem = name: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit system inputs; };
          modules = [
            ./hosts/${name}/hardware.nix
            ./hosts/${name}/configuration.nix
            ./modules/base.nix
            ./modules/workstation.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.jamiez = import ./hosts/${name}/home.nix;
            }
          ];
        };
      in
      {
        boson = mkLinuxSystem "boson";
        neutrino = mkLinuxSystem "neutrino";
      };
  };
}
