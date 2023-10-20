{ pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [ "ruby-2.7.8" "openssl-1.1.1w" ];
  home.packages = [ pkgs.ruby_2_7 ];
  home.file = {
    ".gemrc".source = ./gemrc;
    ".irbrc".source = ./irbrc;
  };
}
