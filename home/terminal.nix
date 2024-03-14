inputs@{ pkgs, ... }:
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
  _ = throw (builtins.trace inputs inputs);
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
    lazygit # Better git UI
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
      envExtra = ''

        	export NVM_DIR="$HOME/.nvm"
        	function nvm() {
        	  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        	  nvm "$@"
        	}
        	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        	export PATH="/Users/amansingh/.scripts:/Users/amansingh/Library/Python/3.8/bin:/usr/local/opt/postgresql@13/bin:/usr/local/opt/openjdk@8/bin:/usr/local/sbin:$PATH"
        	export PATH="/Users/amansingh/.pyenv/versions/2.7.18/bin:$PATH"

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
      # userName = "John Doe";
      # userEmail = "johndoe@example.com";
      extraConfig = {
        # init.defaultBranch = "master";
      };
    };
    tmux = {
      enable = true;
      mouse = true;
      baseIndex = 1;
      historyLimit = 20000;
      extraConfig = ''
                        bind v copy-mode
                        setw -g mode-keys vi
                	run-shell ~/nix-config/home/tmux/plugins/tmux-power.tmux
        		set -g @treemux-tree-nvim-init-file ${treemux.outPath}/share/tmux-plugins/treemux/configs/treemux_init.lua
        		run-shell ${treemux.outPath}/share/tmux-plugins/treemux/sidebar.tmux
      '';
      plugins = with pkgs; [ ];
    };
  };
}
