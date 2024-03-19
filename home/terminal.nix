{ pkgs, ... }:
let
  treemux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "treemux";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "kiyoon";
      repo = "treemux";
      rev = "c97045c55a8068e367eb876319c80c3d99bdccc8";
      sha256 = "sha256-wFPV9LiRF83kBx+gQRwSa7HSvqVxnmsutxfB0XhN0uU=";
    };
  };
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-tokyo-night";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "fabioluciano";
      repo = "tmux-tokyo-night";
      rev = "ee73d4a9ba6222d7d51492a4e0e797c9249a879c";
      sha256 = "sha256-wWWxO6XNcfKO1TRxBhxd8lJLn7wIxyX4Fm1Nd2Rhbkw=";
    };
  };
  delta-themes = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig";
    sha256 = "sha256:09kfrlmrnj5h3vs8cwfs66yhz2zpgk0qnmajvsr57wsxzgda3mh6";
  };
  # Platform-independent terminal setup
in {
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    nixci

    # Dev
    just
    tmate

    nix-health
    nixfmt
    ghostscript
  ];

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # Programs natively supported by home-manager.
  programs = {
    bat.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    htop.enable = true;

    # command-not-found handler to suggest nix way of installing stuff.
    # FIXME: This ought to show new nix cli commands though:
    # https://github.com/nix-community/nix-index/issues/191
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      autocd = true;
      history = {
        size = 100000000;
        expireDuplicatesFirst = true;
        save = 100000000;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "direnv" "fzf" ];
      };
      envExtra = ''
                export NVM_DIR="$HOME/.nvm"
                function nvm() {
                  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                	nvm "$@"
              	}
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
                export PATH="/Users/amansingh/.scripts:/Users/amansingh/Library/Python/3.8/bin:/usr/local/opt/postgresql@13/bin:/usr/local/opt/openjdk@8/bin:/usr/local/sbin:$PATH"
                export PATH="/Users/amansingh/.pyenv/versions/2.7.18/bin:$PATH"
		export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH

                # Make Nix and home-manager installed things available in PATH.
                export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
                [ -f "/Users/amansingh/.ghcup/env" ] && source "/Users/amansingh/.ghcup/env" # ghcup-env
      '';
    };

    # https://zero-to-flakes.com/direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # https://nixos.asia/en/git
    git = {
      enable = true;
      includes = [
        { path = delta-themes; }
      ];
      extraConfig = {
        init.defaultBranch = "master";
        core = {
          fsmonitor = true;
        };
        push.autoSetupRemote = true;
        #diff.algorithm = "histogram";
        merge.conflictstyle = "zdiff3";
      };
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = true;
          features = "mellow-barbet";
        };
      };
    };
    tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      historyLimit = 20000;
      escapeTime = 150;
      terminal = "tmux-256color";
      keyMode = "vi";
      extraConfig = ''
        bind v copy-mode
        bind -n C-k clear-history
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe pbcopy
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel pbcopy
        bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel pbcopy
        set -g @treemux-tree-nvim-init-file ${treemux}/share/tmux-plugins/treemux/configs/treemux_init.lua
        run-shell ${treemux}/share/tmux-plugins/treemux/sidebar.tmux
        set -g @theme_variation 'storm'
        run-shell ${tokyo-night}/share/tmux-plugins/tmux-tokyo-night/tmux-tokyo-night.tmux
      '';
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          activeBorderColor = ["#89b4fa" "bold"];
          inactiveBorderColor = "#a6adc8";
          optionsTextColor = "#89b4fa";
          selectedLineBgColor = "#313244";
          selectedRangeBgColor = "#313244";
          cherryPickedCommitBgColor = "#45475a";
          cherryPickedCommitFgColor = "#89b4fa";
          unstagedChangesColor = "#f38ba8";
          defaultFgColor = "#cdd6f4";
          searchingActiveBorderColor = "#f9e2af";
        };
      };
    };
  };
}
