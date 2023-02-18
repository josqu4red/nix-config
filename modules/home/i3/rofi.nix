{ pkgs }: {
  enable = true;
  theme = ./nord.rasi;
  package = pkgs.rofi.override {
    plugins = with pkgs; [ rofi-emoji ];
  };
}
