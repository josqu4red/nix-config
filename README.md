# nix-config

NixOS configurations for various Linux devices.

## Features

* [schema](doc/facts.md) to describe hosts and home network
* [disko](https://github.com/nix-community/disko) for disk management
* [impermanence](https://github.com/nix-community/impermanence) for stateless systems
* [sops-nix](https://github.com/Mic92/sops-nix) for secrets
* [git-crypt](https://github.com/AGWA/git-crypt) for build-time secrets
* [microvm.nix](https://github.com/astro/microvm.nix) for lightweight virtualization

## Credits/References

Lots of things in here are borrowed from `nix-config` repos out there.
* https://github.com/delroth/infra.delroth.net - the initial one that made me start with Nix
* https://github.com/hlissner/dotfiles - make sure to read the Frequently Asked Questions
* https://github.com/Misterio77/nix-config
* https://github.com/ryan4yin/nixos-rk3588 and https://gitlab.com/K900/nix - for OrangePi 5 parts
