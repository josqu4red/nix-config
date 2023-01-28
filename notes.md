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

cryptsetup --label luks-root luksFormat /dev/${DEV}2
cryptsetup luksOpen /dev/${DEV}2 enc

pvcreate /dev/mapper/enc
vgcreate vg0 /dev/mapper/enc
lvcreate -L 16GiB -n swap vg0
lvcreate -L 100GiB -n root vg0
lvcreate -l '100%FREE' -n home vg0

mkfs.ext4 -L root /dev/vg0/root
mkfs.ext4 -L home /dev/vg0/home
mkswap -L swap /dev/vg0/swap

mount /dev/vg0/root /mnt
mkdir /mnt/boot /mnt/home
mount /dev/vg0/home /mnt/home
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
