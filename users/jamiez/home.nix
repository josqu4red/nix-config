{ inputs, lib, pkgs, username, ... }: {
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ spotify ];

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
    includes = inputs.nixpkgs.lib.optional (builtins.pathExists ./files/gitconfig-work) [{
      condition = "gitdir:~/work/";
      path = ./files/gitconfig-work;
    }];
  };

  my.home = {
    autocutsel.enable = true;
    firefox.enable = true;
    gpg.enable = true;
    nix-tools.enable = true;
    pass.enable = true;
    tmux.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };
}
