{ fetchFromGitHub, buildLinux, ... }: (buildLinux {
  version = "6.10.0-rc5";
  modDirVersion = "6.10.0-rc5";
  extraMeta.branch = "6.10";
  # https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux
  src = fetchFromGitHub {
    owner = "K900";
    repo = "linux";
    rev = "0ed750b5f5937c83ea48664aa56ed3235ae6a305";
    hash = "sha256-M59TlrSmI3tJsz50WFp8+ufS/I4GOk0XiIM2M9Tx4QY=";
  };
})
