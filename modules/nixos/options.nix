{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in {
  options.settings = {
    userShell = mkOption {
      type = types.package;
      default = pkgs.bash;
      example = pkgs.zsh;
      description = "Default user shell";
    };
  };
  options.facts = with types; {
    defaultSystem = mkOption {
      description = "Host platform";
      type = str;
    };
    defaultUsers = mkOption {
      description = "Host users";
      type = listOf str;
    };
    hosts = mkOption {
      description = "List of hosts";
      default = {};
      type = attrsOf (submodule {
        options = {
          system = mkOption {
            description = "Host platform";
            default = "x86_64-linux";
            type = str;
          };
          ip = mkOption {
            description = "Host IPv4 address";
            default = "";
            type = str;
          };
          mac = mkOption {
            description = "Host MAC address";
            default = "";
            type = str;
          };
          users = mkOption {
            description = "Host users";
            default = [];
            type = listOf str;
          };
          vms = mkOption {
            description = "Host microvms";
            default = [];
            type = listOf str;
          };
        };
      });
    };
    homeNet = mkOption {
      description = "Home network settings";
      default = null;
      type = submodule {
        options = {
          defaultGw = mkOption {
            description = "Default gateway";
            default = null;
            type = str;
          };
          domain = mkOption {
            description = "Internal domain name";
            default = null;
            type = str;
          };
          prefix = mkOption {
            description = "Home prefix";
            default = null;
            type = submodule {
              options = {
                address = mkOption {
                  description = "Home prefix address";
                  type = str;
                };
                length = mkOption {
                  description = "Home prefix length";
                  default = 24;
                  type = int;
                };
              };
            };
          };
        };
      };
    };
  };
}
