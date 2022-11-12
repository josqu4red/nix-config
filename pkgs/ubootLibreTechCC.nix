# Flashing instructions:
# dd if=u-boot.gxl.sd.bin of=<sdcard> conv=fsync,notrunc bs=512 skip=1 seek=1
# dd if=u-boot.gxl.sd.bin of=<sdcard> conv=fsync,notrunc bs=1 count=444
{ lib
, buildUBoot
, fetchFromGitHub
}:
let
  firmwareImagePkg = fetchFromGitHub {
    owner = "LibreELEC";
    repo = "amlogic-boot-fip";
    rev = "4369a138ca24c5ab932b8cbd1af4504570b709df";
    sha256 = "sha256-mGRUwdh3nW4gBwWIYHJGjzkezHxABwcwk/1gVRis7Tc=";
    meta.license = lib.licenses.unfreeRedistributableFirmware;
  };
in buildUBoot {
  defconfig = "libretech-cc_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  filesToInstall = ["u-boot.bin"];
  postBuild = ''
    # Copy binary files & tools from LibreELEC/amlogic-boot-fip, and u-boot build to working dir
    mkdir $out tmp
    cp ${firmwareImagePkg}/lepotato/{acs.bin,bl2.bin,bl21.bin,bl30.bin,bl301.bin,bl31.img} \
       ${firmwareImagePkg}/lepotato/{acs_tool.py,aml_encrypt_gxl,blx_fix.sh} \
       u-boot.bin tmp/
    cd tmp
    python3 acs_tool.py bl2.bin bl2_acs.bin acs.bin 0

    bash -e blx_fix.sh bl2_acs.bin zero bl2_zero.bin bl21.bin bl21_zero.bin bl2_new.bin bl2
    [ -f zero ] && rm zero

    bash -e blx_fix.sh bl30.bin zero bl30_zero.bin bl301.bin bl301_zero.bin bl30_new.bin bl30
    [ -f zero ] && rm zero

    ./aml_encrypt_gxl --bl2sig --input bl2_new.bin --output bl2.n.bin.sig
    ./aml_encrypt_gxl --bl3enc --input bl30_new.bin --output bl30_new.bin.enc
    ./aml_encrypt_gxl --bl3enc --input bl31.img --output bl31.img.enc
    ./aml_encrypt_gxl --bl3enc --input u-boot.bin --output bl33.bin.enc
    ./aml_encrypt_gxl --bootmk --output $out/u-boot.gxl \
      --bl2 bl2.n.bin.sig --bl30 bl30_new.bin.enc --bl31 bl31.img.enc --bl33 bl33.bin.enc
  '';
}
