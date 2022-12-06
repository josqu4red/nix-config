# nix-config

NixOS configurations for my Linux machines.

## Credits/References

Lots of things in here are borrowed from lots of `nix-config` repos out there.
In particular:
* https://github.com/delroth/infra.delroth.net - the initial one that made me start with Nix
* https://github.com/hlissner/dotfiles - make sure to read the Frequently Asked Questions
* https://github.com/Misterio77/nix-config
* and many more <3

## Notes

### System REPL

```
nix repl
:lf .
:l <nixpkgs>
:l <nixpkgs/nixos>
```

### LUKS + FIDO2

To unlock LUKS partition with FIDO2 token (passwordless here, boo):
```
nix-shell -p fido2luks
CRED=$(fido2luks credential $(hostname))
sudo FIDO2LUKS_SALT=string: fido2luks add-key /dev/disk/by-label/luks-root $CRED
```
then set
```
boot.initrd.luks = {
  fido2Support = true;
  devices.luks-root = {
    device = "/dev/disk/by-label/luks-root";
    preLVM = true;
    fido2.credential = "$CRED";
    fido2.passwordLess = true;
  };
};
```

TODO: Look into systemd-cryptenroll
