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

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      #overlays = [];
    };
  in
  {
    nixosConfigurations =
      let
        mkLinuxSystem = name: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit system inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/${name}
          ];
        };
      in
      {
        boson = mkLinuxSystem "boson";
        neutrino = mkLinuxSystem "neutrino";
      };

    devShells.${system} = {
      #default = import ./shells/nix.nix { inherit pkgs; } # TODO
      go = import ./shells/go.nix { inherit pkgs; };
    };
  };
}
