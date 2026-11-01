{
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.nxmods.dns = {
    aliases = mkOption {
      description = "Names (relative to the DNS zones) published as CNAMEs to this host by the DNS server";
      default = [ ];
      type = types.listOf types.str;
    };
    cnames = mkOption {
      description = "Map of alias -> hostname, collected from every host's nxmods.dns.aliases";
      readOnly = true;
      type = types.attrsOf types.str;
      default = lib.listToAttrs (
        lib.concatLists (
          lib.mapAttrsToList (
            host: sys: map (a: lib.nameValuePair a host) sys.config.nxmods.dns.aliases
          ) inputs.self.nixosConfigurations
        )
      );
    };
  };
}
