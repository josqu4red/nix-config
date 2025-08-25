{ pkgs, ... }: {
  home.packages = with pkgs; [ tig git-crypt ];
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
    };
    extraConfig = {
      advice = {
        diverging = "false";
        mergeConflict = "false";
      };
      branch.sort = "-committerdate";
      commit.verbose = true;
      core.whitespace = "trailing-space,cr-at-eol";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      init.defaultBranch = "main";
      pull = {
        ff = "only";
        rebase = true;
      };
      push.default = "simple";
      rebase = {
        autoStash = true;
        updateRefs = true;
      };
      tag.sort = "version:refname";
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
  };
}
