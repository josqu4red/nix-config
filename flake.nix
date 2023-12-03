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
    xlib = import ./lib { inherit inputs; };
    inherit (xlib) forAllSystems mkSystem mkHome;
    inherit (builtins) listToAttrs;
    inherit (inputs.nixpkgs.lib) flatten nameValuePair;

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

    hosts = [
      { hostname = "boson"; profile = "desktop"; users = [ "jamiez" ]; inherit pkgs; }
      { hostname = "charm"; profile = "server"; users = [ "jamiez" ]; pkgs = aarch64-pkgs;
        extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; }
      { hostname = "electron"; profile = "server"; users = [ "jamiez" ]; pkgs = aarch64-pkgs;
        extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; }
      { hostname = "neutrino"; profile = "laptop"; users = [ "jamiez" ]; inherit pkgs; }
      { hostname = "quark"; profile = "laptop"; users = [ "jamiez" "sev" ]; inherit pkgs; }
      { hostname = "tau"; profile = "server"; users = [ "jamiez" ]; inherit pkgs; }
    ];
  in {
    inherit legacyPackages;

    nixosModules = import ./modules/nixos;

    nixosConfigurations = listToAttrs (map (h: nameValuePair h.hostname (mkSystem h)) hosts);

    homeConfigurations = listToAttrs (flatten(
      map (host:
        map (username:
          nameValuePair "${username}@${host.hostname}" (mkHome { inherit (host) hostname; inherit username pkgs; })
        ) host.users
      ) hosts
    ));

    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = legacyPackages.${system}; };
    });
  };
}
