{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;

  prefixType = with types; submodule {
    options = {
      address = mkOption {
        description = "Prefix address";
        type = str;
      };
      length = mkOption {
        description = "Prefix length";
        type = int;
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
          aliases = mkOption {
            description = "Host aliases";
            default = [];
            type = listOf str;
          };
        };
      });
    };
    dns = mkOption {
      description = "DNS settings";
      default = null;
      type = submodule {
        options = {
          internalDomain = mkOption {
            description = "Internal domain name";
            default = null;
            type = str;
          };
        };
      };
    };
    networks = mkOption {
      description = "Network settings";
      default = null;
      type = attrsOf (submodule {
        options = {
          gateway = mkOption {
            description = "Default gateway";
            default = null;
            type = str;
          };
          vlan = mkOption {
            description = "VLAN ID";
            default = null;
            type = int;
          };
          prefix = mkOption {
            description = "Network prefix";
            default = null;
            type = prefixType;
          };
          dhcp = mkOption {
            description = "Dynamic prefix";
            default = null;
            type = prefixType;
          };
        };
      });
    };
    config = mkOption {
      description = "General shared config";
      default = {};
      type = attrs;
    };
  };
}
