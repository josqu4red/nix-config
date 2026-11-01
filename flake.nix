{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixpkgs-mongodb.url = "github:NixOS/nixpkgs/9f0c42f8bc7151b8e7e5840fb3bd454ad850d8c5";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (import ./secrets/build/facts.nix { }) facts;
      inherit (lib)
        buildHomeConfigs
        buildNixosConfigs
        expandFacts
        filterSystem
        forAllSystems
        ;

      hosts = expandFacts facts;

      local-pkgs = final: _prev: import ./pkgs { pkgs = final; };

      mongodb-pin = _final: prev: {
        inherit
          (import inputs.nixpkgs-mongodb {
            inherit (prev.stdenv.hostPlatform) system;
            config.allowUnfreePredicate = pkg: "mongodb" == (prev.lib.getName pkg);
          })
          mongodb-7_0
          ;
      };

      # solargraph < 0.58.3 loops forever caching gems (castwide/solargraph#1169).
      # Drop once nixpkgs ships >= 0.58.3.
      solargraph-0-58-3 = _final: prev: {
        rubyPackages = prev.rubyPackages // {
          solargraph = prev.rubyPackages.solargraph.override (old: {
            version = "0.58.3";
            source = old.source // {
              sha256 = "0s9fzq4rax47nvypwq84k4mr0g9pf6gdibf4na1j7ryi4z4zvgny";
            };
            gemPath = old.gemPath ++ [
              prev.rubyPackages.ast
              (prev.buildRubyGem {
                inherit (old) ruby;
                gemName = "open3";
                version = "0.2.1";
                source.sha256 = "0lirpxrqk2bw02m3p4g8r50h37qkr0ssmh9q2hh52qsj2chpsbcf";
              })
            ];
          });
        };
      };

      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            local-pkgs
            mongodb-pin
            solargraph-0-58-3
            # Passthrough so `nix shell .#llma.<tool>` works. Kept out of
            # `packages` because it is an attrset, not a derivation.
            (_final: _prev: { llma = inputs.llm-agents.packages.${system}; })
          ];
        }
      );
    in
    {
      inherit facts legacyPackages lib;

      nixosConfigurations = buildNixosConfigs (filterSystem "linux" hosts);
      nixosModules = import ./modules/nixos;
      nixosProfiles = import ./modules/profiles;

      homeConfigurations = buildHomeConfigs hosts;
      homeModules = import ./modules/home-manager;

      devShells = forAllSystems (system: {
        default = import ./shell.nix {
          pkgs = legacyPackages.${system};
          inherit (inputs.sops-nix.packages.${system}) sops-import-keys-hook;
          inherit (inputs.ssh-to-pgp.packages.${system}) ssh-to-pgp;
        };
        fhsEnv = import ./pkgs/fhsEnv.nix { pkgs = legacyPackages.${system}; };
      });

      packages."x86_64-linux".nixlive = self.nixosConfigurations.nixlive.config.system.build.images.iso;

      apps."x86_64-linux".nixlive-vm =
        let
          vm = self.nixosConfigurations.nixlive.config.system.build.vm;
        in
        {
          type = "app";
          program = nixpkgs.lib.getExe vm;
        };
    };
}
