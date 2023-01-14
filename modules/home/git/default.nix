{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.home.git;
in {
  options.my.home.git = {
    enable = mkEnableOption "git";
    includes = mkOption {
      type = with types; listOf attrs;
      default = [];
      example = [ ./a/file ];
      description = "Extra includes for gitconfig (per directory, ...)";
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Jonathan Amiez";
      userEmail = "jonathan.amiez@gmail.com";
      signing.key = "18811A0493F64AC5";
      aliases = {
        st = "status -sb";
        ci = "commit";
        co = "checkout";
        cp = "cherry-pick";
        br = "branch";
        amend = "commit --amend --no-edit";
        difc = "diff --cached";
        gr = "!g() { if [ $# -eq 1 ]; then b=$1; else b=master; fi; git push origin HEAD:refs/for/$b/$(git rev-parse --abbrev-ref HEAD); }; g";
        grd = "!gd() { if [ $# -eq 1 ]; then b=$1; else b=master; fi; git push origin HEAD:refs/drafts/$b/$(git rev-parse --abbrev-ref HEAD); }; gd";
      };
      extraConfig = {
        core = { whitespace = "trailing-space,cr-at-eol"; };
        push.default = "simple";
        pull.ff = "only";
        init.defaultBranch = "main";
        color = {
          diff = {
           meta = "blue bold";
           frag = "magenta bold";
           old = "red bold";
           new = "green bold";
          };
          branch = {
           current = "yellow reverse";
           local = "yellow bold";
           remote = "green bold";
           plain = "red bold";
          };
          status = {
           added = "yellow";
           changed = "green bold";
           untracked = "blue bold";
          };
        };
      };
      includes = cfg.includes;
    };
  };
}
