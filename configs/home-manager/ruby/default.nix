{ pkgs, ... }: {
  home.packages = [ pkgs.ruby ];
  home.file = {
    ".gemrc".source = ./gemrc;
    ".irbrc".source = ./irbrc;
  };
}
