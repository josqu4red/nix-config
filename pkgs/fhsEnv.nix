#   https://nixos.wiki/wiki/Linux_kernel#Embedded_Linux_Cross-compile_xconfig_and_menuconfig
{ pkgs }: (pkgs.buildFHSUserEnv {
  name = "kernel-build-env";
  targetPkgs = pkgs_: (with pkgs_;
    [
      pkg-config
      ncurses
      # arm64 cross-compilation toolchain
      pkgsCross.aarch64-multiplatform.gcc12Stdenv.cc
      # native gcc
      gcc12
    ]
    ++ pkgs.linux.nativeBuildInputs);
  runScript = pkgs.writeScript "init.sh" ''
    # set the cross-compilation environment variables.
    export CROSS_COMPILE=aarch64-unknown-linux-gnu-
    export ARCH=arm64
    export PKG_CONFIG_PATH="${pkgs.ncurses.dev}/lib/pkgconfig:"
    exec bash
  '';
}).env
