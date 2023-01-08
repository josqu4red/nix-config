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

### Gnome / xkbconfig

If `services.xserver.xkbOptions = "caps:swapescape"` has no effect:
```
gsettings reset org.gnome.desktop.input-sources xkb-options
```
/!\ resets input methods
