{ lib, pkgs, runCommand, nixosOptionsDoc }: let
  makeOptionsDoc = module: nixosOptionsDoc {
    inherit ((lib.evalModules {
      modules = [
        module
        ({ lib, ... }: {
          # Provide `pkgs` arg to all modules
          config._module.args.pkgs = pkgs;
          # Hide NixOS `_module.args` from nixosOptionsDoc to remain
          # specific to microvm.nix
          options._module.args = lib.mkOption {
            internal = true;
          };
        })
      ];
    })) options;

    transformOptions = opt: opt // {
      declarations = map (decl:
        let
          root = toString ../.;
          declStr = toString decl;
          declPath = lib.removePrefix root decl;
        in
          if lib.hasPrefix root declStr
          # Rewrite links from ../. in the /nix/store to the source on Github
          then {
            name = "nix-config${declPath}";
            url = "https://github.com/josqu4red/nix-config/tree/main${declPath}";
          }
          else decl
      ) opt.declarations;
    };
  };

  factsDoc = makeOptionsDoc ../modules/nixos/options.nix;
in
  runCommand "nix-doc" {} ''
    mkdir -p $out
    cat ${factsDoc.optionsCommonMark} >> $out/facts.md
  ''
