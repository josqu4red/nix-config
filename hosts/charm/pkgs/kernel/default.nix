{
  fetchzip,
  linuxManualConfig,
  ubootTools,
  ...
}:
(linuxManualConfig {
  version = "5.10.160-armbian-rk3588";
  modDirVersion = "5.10.160";

  # https://github.com/armbian/linux-rockchip/tree/rk-5.10-rkr4
  src = fetchzip {
    # branch: rk-5.10-rkr4
    # date: 2023-08-08
    url = "https://github.com/armbian/linux-rockchip/archive/8cae9a3e884071996260905575b55136e2480f6b.zip";
    sha256 ="sha256-9pp9OXRMY8RUq4Fn5AcYhiGeyXXDPRAm9fUVzQV5L2k=";
  };

  configfile = ./orangepi5_config;

  extraMeta.branch = "5.10";

  allowImportFromDerivation = true;
})
.overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ubootTools];
})
