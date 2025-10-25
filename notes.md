# Notes

## System REPL

```
nix repl
:lf .
:l <nixpkgs>
:l <nixpkgs/nixos>
```

## Manual install

### Partitioning

TODO: disko!

* Create GPT partition table
* Create EFI and LUKS partition

```
DEV=/dev/xxx
mkfs.fat -F 32 -n efi /dev/${DEV}1

cryptsetup --label system luksFormat /dev/${DEV}2
cryptsetup luksOpen /dev/${DEV}2 system

pvcreate /dev/mapper/system
vgcreate system /dev/mapper/system
lvcreate -L 16GiB -n swap system
lvcreate -L 100GiB -n root system
lvcreate -l '100%FREE' -n home system

mkfs.ext4 -L root /dev/system/root
mkfs.ext4 -L home /dev/system/home
mkswap -L swap /dev/system/swap

mount /dev/system/root /mnt
mkdir /mnt/boot /mnt/home
mount /dev/system/home /mnt/home
mount /dev/${DEV}1 /mnt/boot
```

### Network

```
cat > /mnt/wpa.conf
network={
  ssid="****"
  psk="****"
}
screen wpa_supplicant -Dnl80211 -iwlp0s20f3 -c/mnt/wpa.conf
```

### Install

```
nixos-generate-config --root /mnt
cd /mnt; git clone this repo
cp /mnt/etc/nixos/hardware-configuration.nix nix-config/hosts/hostname/hardware.nix
nixos-install --root /mnt --flake /mnt/nix-config#hostname
reboot
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

## Misc

### Gnome / xkbconfig

If `services.xserver.xkbOptions = "caps:swapescape"` has no effect:
```
gsettings reset org.gnome.desktop.input-sources xkb-options
```
/!\ resets input methods

### Foreign architectures

#### Cross-compilation

Use pkgsCross package set on target host:

```
target = mkSystem { pkgs = pkgs.pkgsCross.aarch64-multiplatform; ... };
```

#### Emulation

Enable QEMU binfmt wrapper on build host:

```
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```

Use target architecture package set on target host + pass pkgsCross if needed:

```
target = mkSystem { pkgs = legacyPackages."aarch64-linux"; extraArgs = { pkgsCross = pkgs.pkgsCross.aarch64-multiplatform; }; };
```
