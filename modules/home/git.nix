{ config, ... }:
let
  delta-themes = builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig";
    sha256 = "sha256:09kfrlmrnj5h3vs8cwfs66yhz2zpgk0qnmajvsr57wsxzgda3mh6";
  };
in
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      userName = config.me.fullname;
      userEmail = config.me.email;
      ignores = [ "*~" "*.swp" ];
      aliases = {
        ci = "commit";
      };
      extraConfig = {
        init.defaultBranch = "master";
        core = { fsmonitor = true; };
        push.autoSetupRemote = true;
        diff.algorithm = "histogram";
        merge.conflictstyle = "zdiff3";
      };
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = false;
          features = "mellow-barbet";
        };
      };
      includes = [{ path = delta-themes; }];
    };
    lazygit.enable = true;
  };

}
