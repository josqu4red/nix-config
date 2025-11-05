{ pkgs, ... }: {
  home.packages = with pkgs; [ wl-clipboard ];
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
}
