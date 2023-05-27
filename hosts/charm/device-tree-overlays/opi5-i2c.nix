{
  name = "orangepi5-i2c-overlay";
  dtsText = ''
    /dts-v1/;
    /plugin/;

    / {
      compatible = "rockchip,rk3588s-orangepi-5";

      fragment@0 {
        target = <&i2c1>;

        __overlay__ {
          status = "okay";
          pinctrl-names = "default";
          pinctrl-0 = <&i2c1m2_xfer>;
        };
      };
    };
  '';
}
