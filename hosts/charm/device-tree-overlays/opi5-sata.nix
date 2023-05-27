{
  name = "orangepi5-sata-overlay";
  dtsText = ''
    // Orange Pi 5 Pcie M.2 to sata
    /dts-v1/;
    /plugin/;

    / {
      compatible = "rockchip,rk3588s-orangepi-5";

      fragment@0 {
        target = <&sata0>;

        __overlay__ {
          status = "disabled";
        };
      };

      fragment@1 {
        target = <&pcie2x1l2>;

        __overlay__ {
          status = "okay";
        };
      };
    };
  '';
}
