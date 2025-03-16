{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;

  prefixSubmodule = name: with types; mkOption {
    description = "${name} prefix";
    default = null;
    type = submodule {
      options = {
        address = mkOption {
          description = "${name} prefix address";
          type = str;
        };
        length = mkOption {
          description = "${name} prefix length";
          type = int;
        };
      };
    };
  };
in with types; {
  options.settings = {
    userShell = mkOption {
      type = package;
      default = pkgs.bash;
      example = pkgs.zsh;
      description = "Default user shell";
    };
  };
  options.facts = {
    defaults = mkOption {
      description = "Host defaults";
      default = {};
      type = submodule {
        options = {
          stateVersion = mkOption {
            description = "Default stateVersion";
            default = "22.05";
            type = str;
          };
          system = mkOption {
            description = "Default host platform";
            default = "x86_64-linux";
            type = str;
          };
          users = mkOption {
            description = "Default host users";
            default = [];
            type = listOf str;
          };
        };
      };
    };
    hosts = mkOption {
      description = "List of hosts";
      default = {};
      type = attrsOf (submodule {
        options = {
          stateVersion = mkOption {
            description = "State version";
            default = config.facts.defaults.stateVersion;
            type = str;
          };
          system = mkOption {
            description = "Host platform";
            default = config.facts.defaults.system;
            type = str;
          };
          users = mkOption {
            description = "Host users";
            default = config.facts.defaults.users;
            type = listOf str;
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
          netIf = mkOption {
            description = "Host main network interface";
            default = "";
            type = str;
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
          prefix = prefixSubmodule "Home";
          dhcp = prefixSubmodule "Dynamic";
        };
      };
    };
    config = mkOption {
      description = "General shared config";
      default = {};
      type = attrs;
    };
  };
}
