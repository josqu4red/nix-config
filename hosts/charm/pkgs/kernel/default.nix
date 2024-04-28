{ fetchFromGitHub, buildLinux, ... }: (buildLinux {
  version = "6.9.0-rc6";
  modDirVersion = "6.9.0-rc6";
  extraMeta.branch = "6.9";
  # https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux
  src = fetchFromGitHub {
    owner = "K900";
    repo = "linux";
    rev = "0c638f3f28789c6af7cbbbbaff2efd6dc268cc53";
    hash = "sha256-qJXiCo8iL60zhZgSMLZwN8pdkEeqJ0CQHgRt/vjWmT4=";
  };
})
