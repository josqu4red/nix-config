{ inputs, pkgs, lib, hostname, hostFacts, secrets, ... }: let
  defaultPackages = with pkgs; [
    bc
    binutils
    colordiff
    curl
    dig
    file
    git
    htop
    jq
    less
    lsof
    ncdu
    nettools
    nvd
    rsync
    screen
    socat
    strace
    sysstat
    tree
    unzip
    vim
  ];
  nixpkgsPath = "/etc/nixpkgs/channels/nixpkgs";
in {
  system.stateVersion = hostFacts.stateVersion;
  nixpkgs.hostPlatform = hostFacts.system;

  boot.swraid.enable = lib.mkDefault false; # true for stateVersion < 23.11

  networking.hostName = hostname;

  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.utf8";
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  users.users.root.hashedPassword = secrets.root-password;
  security.sudo.wheelNeedsPassword = false;

  programs.nano.enable = false;
  environment = {
    systemPackages = defaultPackages;
    variables = {
      EDITOR = "vim";
      PAGER = "less";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "no";
    };
  };

  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ]; # TODO: figure out signing
      experimental-features = [ "nix-command" "flakes" ];
      cores = 0;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Use flake's nixpkgs input in NIX_PATH, with systemd.tmpfiles below
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${nixpkgsPath}" ];
  };
  systemd.tmpfiles.rules = [ "L+ ${nixpkgsPath} - - - - ${inputs.nixpkgs}" ];
}
